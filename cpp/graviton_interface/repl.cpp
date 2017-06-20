#include <iostream>
#include <iomanip>
#include <fstream>
#include <chrono>
#include <thread>
#include <mutex>
#include <condition_variable>
#include <cstring>

#include <vector>
#include <string>
#include <map>

#include "gthreads.h"
#include "sysdef.h"
using namespace sysdef;

////////////////////////////////
// Inter-thread communication
////////////////////////////////
extern std::mutex m_global_quit;
extern bool global_quit;

extern std::mutex m_magic_value;
extern unsigned magic_value;

extern std::mutex m_signal_data;
extern signal_params signal_data;

extern std::mutex m_statistics;
extern dsp_stats statistics;

extern std::mutex m_dumper;
extern dump_params dump_data;

////////////////////////////////
// Local constants
////////////////////////////////
// Maximum length of a command string
constexpr int MAX_CMD_TXT = 1024;

enum cmd_id_t { // Command IDs
    UNKNOWN_ID,
    HELP_ID,
    QUIT_ID,
    TXMAGIC_ID,
    RXMAGIC_ID,
    SEND_ID,
    POLLSTATS_ID,
    DUMP_ID,
    PLOT_ID
};

////////////////////////////////
// Local function declarations
////////////////////////////////
static bool compare(const char s1[], const char s2[]);
int command_count(char *cmd_start, int cmd_index, std::string comm_string);
int whitespace_count(char *cmd_start, int cmd_index);
int nonwhitespace_count(char *cmd_start, int cmd_index);
static bool is_whitespace(const char ch);
static void to_lowercase(char s[], const int len);

/////////////////////////////////////////////////////
// Read-eval-print loop thread entry point
/////////////////////////////////////////////////////
void repl(void)
{
    bool local_quit = false;
    char cmd_txt[MAX_CMD_TXT];
    char *cmd_start = 0;

    // Command string definitions
    const std::string help_command {"help"}; // help <command>
    const std::string quit_command {"quit"}; // quit
    const std::string q_command {"q"}; // quit
    const std::string exit_command {"exit"}; // exit (synonym for quit)
    const std::string txmagic_command = {"txmagic"}; // Send TX magic sample
    const std::string rxmagic_command = {"rxmagic"}; // Send RX magic sample
    const std::string send_command = {"send"}; // Send a sine wave, zeros, random sequence, etc.
    const std::string pollstats_command = {"pollstats"}; // Poll link statistics
    const std::string p_command = {"p"}; // Poll link statistics
    const std::string dump_command = {"dump"}; // Dump data from RX
    const std::string plot_command = {"plot"}; // Plot data dump

    // Map of strings to IDs
    std::map<std::string, cmd_id_t> commands;
    commands.insert(std::pair<std::string, cmd_id_t>(help_command, HELP_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(quit_command, QUIT_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(q_command, QUIT_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(exit_command, QUIT_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(txmagic_command, TXMAGIC_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(rxmagic_command, RXMAGIC_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(send_command, SEND_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(pollstats_command, POLLSTATS_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(p_command, POLLSTATS_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(dump_command, DUMP_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(plot_command, PLOT_ID));

    // Help string definitions
    const std::string help_help {"displays a list of commands; help <command> : lists help about a command"};
    const std::string help_quit {"exits the program; exit : also exits the program"};
    const std::string help_txmagic {"sends txmagic to graviton"};
    const std::string help_rxmagic {"sends rxmagic to graviton"};
    const std::string help_send {"sends signal to graviton"};
    const std::string help_pollstats {"polls stats of link to graviton"};
    const std::string help_dump {"dumps adc data to a file"};
    const std::string help_plot {"plots adc data previously dumped to a file (eventually will allow subsets to be plotted)"};

    // Map of help strings
    std::map<std::string, std::string> help_strings;
    help_strings.insert(std::pair<std::string, std::string>(help_command, help_help));
    help_strings.insert(std::pair<std::string, std::string>(quit_command, help_quit));
    help_strings.insert(std::pair<std::string, std::string>(txmagic_command, help_txmagic));
    help_strings.insert(std::pair<std::string, std::string>(rxmagic_command, help_rxmagic));
    help_strings.insert(std::pair<std::string, std::string>(send_command, help_send));
    help_strings.insert(std::pair<std::string, std::string>(pollstats_command, help_pollstats));
    help_strings.insert(std::pair<std::string, std::string>(dump_command, help_dump));
    help_strings.insert(std::pair<std::string, std::string>(plot_command, help_plot));

    while (!local_quit) {
        // Request user for command input
        std::cout << "    command? ";

        // Obtain command input from standard input
        std::cin.getline(cmd_txt, MAX_CMD_TXT-1);
        std::cout << std::endl;

        // Convert to lowercase
        to_lowercase(cmd_txt, MAX_CMD_TXT);
        // Remove whitespace
        int cmd_index;
        for (cmd_index = 0, cmd_start = &cmd_txt[0]; cmd_index < MAX_CMD_TXT; ++cmd_index, ++cmd_start) {
            if (is_whitespace(*cmd_start)) {
                continue;
            }
            break;
        }
        // If no text is remaining, request input again
        if (std::strlen(cmd_start) == 0) {
            continue;
        }
        // If text is remaining convert the command string to the cmd_id enum type
        // for further processing.
        int str_length = 0;
        for (auto i = cmd_index; i < MAX_CMD_TXT; ++i) {
            if (is_whitespace(cmd_txt[i]) || (cmd_txt[i] == '\0')) {
                break;
            }
            ++str_length;
        }
        auto cmd_string = std::string(cmd_start, str_length);
        auto cmd_id_iter = commands.find(cmd_string);
        cmd_id_t cmd_id;
        if (cmd_id_iter == commands.end()) {
            cmd_id = UNKNOWN_ID;
        }
        else {
            cmd_id = commands[cmd_string];
        }

        // Evaluate text command input
        switch (cmd_id) {
            case HELP_ID: {
                // skip command word
                int acnt = command_count(cmd_start, cmd_index, help_command);
                cmd_start += acnt; cmd_index += acnt;
                // skip whitespace
                acnt = whitespace_count(cmd_start, cmd_index);
                cmd_start += acnt; cmd_index += acnt;
                // If there is more text, then we are in the help <command> context
                if(std::strlen(cmd_start) > 0) {
                    // TODO: print help for a specified command
                    std::cout << "No information for command: ";
                    std::cout << (&cmd_start[0]) << std::endl;
                    std::cout << std::endl;
                }
                else {
                    // Otherwise, print the help messages
                    for(auto it = help_strings.begin(); it != help_strings.end(); ++it) {
                        std::cout << std::setw(20);
                        std::cout << it->first << " : " << it->second << std::endl;
                    }
                    std::cout << std::endl;
                }
                break;
            } // end HELP_ID
            case QUIT_ID: {
                local_quit = 1;
                break;
            } // end QUIT_ID
            case TXMAGIC_ID: {
                {
                    std::unique_lock<std::mutex> magic_lock(m_magic_value);
                    magic_value = TXMAGIC;
                }
                std::cout << "Sending TX Magic" << std::endl;
                std::cout << std::endl;
                break;
            }
            case RXMAGIC_ID: {
                {
                    std::unique_lock<std::mutex> magic_lock(m_magic_value);
                    magic_value = RXMAGIC;
                }
                std::cout << "Sending RX Magic" << std::endl;
                std::cout << std::endl;
                break;
            }
            case SEND_ID: {
                // skip command word
                int acnt = command_count(cmd_start, cmd_index, send_command);
                cmd_start += acnt; cmd_index += acnt;
                // skip whitespace
                acnt = whitespace_count(cmd_start, cmd_index);
                cmd_start += acnt; cmd_index += acnt;
                // If there is no more text, then print the command usage.
                if (std::strlen(cmd_start) == 0) {
                    constexpr int FMT_WIDTH = 45;
                    std::cout << "    Usage:" << std::endl;
                    // SEND NOTHING
                    std::cout << "      " << std::setw(FMT_WIDTH) << std::left << "send nothing";
                    std::cout << " : sends a sequence of zeros" << std::endl;
                    // SEND RAMP
                    std::cout << "      " << std::setw(FMT_WIDTH) << std::left << "send ramp";
                    std::cout << " : sends an incrementing count" << std::endl;
                    // SEND RANDOM
                    std::cout << "      " << std::setw(FMT_WIDTH) << std::left << "send random";
                    std::cout << " : sends completely random data" << std::endl;
                    // SEND SINE
                    std::cout << "      " << std::setw(FMT_WIDTH) << std::left << "send sine <frequency=0.0> <amplitude=MAX>";
                    std::cout << " : sends sinusoid to dac" << std::endl;
                    // SEND SWEEP
                    std::cout << "      " << std::setw(FMT_WIDTH) << std::left << "send sweep <rate=0.00025> <amplitude=MAX>";
                    std::cout << " : sends swept sine to dac" << std::endl;
                    // send newline
                    std::cout << std::endl;
                    // MORE INFORMATION
                    std::cout << "    Note: All words are required, floating point or integer arguments" << std::endl;
                    std::cout << "    in angle brackets are required if they do not have a specified" << std::endl;
                    std::cout << "    default value." << std::endl;
                    // send newline
                    std::cout << std::endl;
                }
                else {
                    if (compare(cmd_start, "nothing")) {
                        std::cout << "Sending zero signal" << std::endl;
                        m_signal_data.lock();
                        signal_data.needs_update = 1;
                        signal_data.mode = SIGNAL_ZERO;
                        signal_data.amplitude = 0.0;
                        signal_data.frequency = 0.0;
                        signal_data.sweep_rate = 0.0;
                        m_signal_data.unlock();
                    }
                    else if (compare(cmd_start, "ramp")) {
                        std::cout << "Sending ramp signal" << std::endl;
                        m_signal_data.lock();
                        signal_data.needs_update = 1;
                        signal_data.mode = SIGNAL_RAMP;
                        signal_data.amplitude = 0.0;
                        signal_data.frequency = 0.0;
                        signal_data.sweep_rate = 0.0;
                        m_signal_data.unlock();
                    }
                    else if (compare(cmd_start, "random")) {
                        std::cout << "Sending random signal" << std::endl;
                        m_signal_data.lock();
                        signal_data.needs_update = 1;
                        signal_data.mode = SIGNAL_RANDOM;
                        signal_data.amplitude = 0.0;
                        signal_data.frequency = 0.0;
                        signal_data.sweep_rate = 0.0;
                        m_signal_data.unlock();
                    }
                    else if (compare(cmd_start, "sine")) {
                        double frequency = 0.0;
                        double amplitude = DAC_FULL_SCALE;

                        // Consume "sine" + whitespace
                        cmd_start += 4; cmd_index += 4;
                        acnt = whitespace_count(cmd_start, cmd_index);
                        cmd_start += acnt; cmd_index += acnt;

                        // If there is more text, then read frequency
                        if (std::strlen(cmd_start) > 0) {
                            std::sscanf(cmd_start, "%lf", &frequency);
                            frequency *= 2.0 * PI;
                        }

                        // Consume number + whitespace
                        acnt = nonwhitespace_count(cmd_start, cmd_index);
                        cmd_start += acnt; cmd_index += acnt;
                        acnt = whitespace_count(cmd_start, cmd_index);
                        cmd_start += acnt; cmd_index += acnt;

                        // If there is more text, then read amplitude
                        if (std::strlen(cmd_start) > 0) {
                            std::sscanf(cmd_start, "%lf", &amplitude);
                        }

                        std::cout << "Sending sine signal" << std::endl;
                        m_signal_data.lock();
                        signal_data.needs_update = 1;
                        signal_data.mode = SIGNAL_SINE;
                        signal_data.amplitude = amplitude;
                        signal_data.frequency = frequency;
                        signal_data.sweep_rate = 0.0;
                        m_signal_data.unlock();
                    }
                    else if (compare(cmd_start, "sweep")) {
                        double rate = 2.0 * PI * 0.00025;
                        double amplitude = DAC_FULL_SCALE;

                        // Consume "sweep" + whitespace
                        cmd_start += 5; cmd_index += 5;
                        acnt = whitespace_count(cmd_start, cmd_index);
                        cmd_start += acnt; cmd_index += acnt;

                        // If there is more text, then read rate
                        if (std::strlen(cmd_start) > 0) {
                            std::sscanf(cmd_start, "%lf", &rate);
                            rate *= 2.0 * PI;
                        }

                        // Consume number + whitespace
                        acnt = nonwhitespace_count(cmd_start, cmd_index);
                        cmd_start += acnt; cmd_index += acnt;
                        acnt = whitespace_count(cmd_start, cmd_index);
                        cmd_start += acnt; cmd_index += acnt;

                        // If there is more text, then read amplitude
                        if (std::strlen(cmd_start) > 0) {
                            std::sscanf(cmd_start, "%lf", &amplitude);
                        }

                        std::cout << "Sending sweep signal" << std::endl;
                        m_signal_data.lock();
                        signal_data.needs_update = 1;
                        signal_data.mode = SIGNAL_SWEEP;
                        signal_data.amplitude = amplitude;
                        signal_data.frequency = 0.0;
                        signal_data.sweep_rate = rate;
                        m_signal_data.unlock();
                    }
                    else {
                        std::cout << "Unrecognized signal " << cmd_start << std::endl;
                    }
                    std::cout << std::endl;
                }
                break;
            }
            case POLLSTATS_ID: {
                // TODO: make this work
                std::cout << "Polling Link Statistics" << std::endl;
                m_statistics.lock();
                std::cout << "           iteration: " << statistics.iteration << std::endl;
                std::cout << std::endl;
                std::cout << "  <<<<<<<<<<<<<<<<<<< ADC STATS >>>>>>>>>>>>>>>>>>>" << std::endl;
                std::cout << "     sequence number: " << statistics.adc_sequence_number << std::endl;
                std::cout << "        failed reads: " << statistics.adc_failed_read_count << std::endl;
                std::cout << " UDP sequence errors: " << statistics.adc_udp_sequence_error_count << std::endl;
                std::cout << std::endl;
                std::cout << "  <<<<<<<<<<<<<<<<<<< DAC STATS >>>>>>>>>>>>>>>>>>>" << std::endl;
                std::cout << "     sequence number: " << statistics.dac_sequence_number << std::endl;
                std::cout << "   almost full flags: " << statistics.dac_buffer_almost_full_count << std::endl;
                std::cout << "     underflow flags: " << statistics.dac_buffer_underflow_count << std::endl;
                std::cout << "      overflow flags: " << statistics.dac_buffer_overflow_count << std::endl;
                std::cout << " UDP sequence errors: " << statistics.dac_udp_sequence_error_count << std::endl;
                std::cout << std::endl;
                m_statistics.unlock();
                std::cout << std::endl;
                break;
            }
            case DUMP_ID: {
                int acnt = command_count(cmd_start, cmd_index, dump_command);
                cmd_start += acnt; cmd_index += acnt;
                // skip whitespace
                acnt = whitespace_count(cmd_start, cmd_index);
                cmd_start += acnt; cmd_index += acnt;

                if (std::strlen(cmd_start) == 0) {
                    constexpr int FMT_WIDTH = 45;
                    std::cout << "    Usage:" << std::endl;
                    // DUMP ON
                    std::cout << "      " << std::setw(FMT_WIDTH) << std::left << "dump on";
                    std::cout << " : enable data dumping for ADC" << std::endl;
                    // DUMP OFF
                    std::cout << "      " << std::setw(FMT_WIDTH) << std::left << "dump off";
                    std::cout << " : disable data dumping for ADC" << std::endl;
                    // DUMP [N]
                    std::cout << "      " << std::setw(FMT_WIDTH) << std::left << "dump 10";
                    std::cout << " : enable data dumping for 10 packets, then disable" << std::endl;
                }
                else {
                    if (((*cmd_start) > '0') && ((*cmd_start) < '9')) {
                        unsigned long long dumps_to_get = 0;
                        std::sscanf(cmd_start, "%llu", &dumps_to_get);
                        std::cout << "        ADC data dump enabled for ";
                        std::cout << dumps_to_get << " packets." << std::endl;
                        dump_data.needs_update = 1;
                        dump_data.dumps_left = dumps_to_get;
                    }
                    else if (compare(cmd_start, "on")) {
                        std::cout << "        ADC data dump enabled." << std::endl;
                        dump_data.needs_update = 1;
                        dump_data.dumps_left = 0xFFFFFFFFFFFFFFFFULL;
                    }
                    else if (compare(cmd_start, "off")) {
                        std::cout << "        ADC data dump disabled." << std::endl;
                        dump_data.needs_update = 1;
                        dump_data.dumps_left = 0;
                    }
                    else {
                        std::cout << "Unrecognized format of dump command." << std::endl;
                    }
                }

                std::cout << std::endl;
                break;
            }
            case PLOT_ID: {
                std::cout << "Plotting dumped data" << std::endl;
                std::system("python plot_adc_data.py");
                std::cout << std::endl;
                break;
            }
            default: {
                std::cout << "Unrecognized command: " << cmd_start << std::endl;
                break;
            } // end default
        } // end switch

        // Verify that no one has signaled us to quit.
        {
            std::unique_lock<std::mutex>(m_global_quit);
            if (global_quit != 0) {
                local_quit = global_quit;
            }
        }
    }

    // Signal to all threads that the application is quitting.
    {
        std::unique_lock<std::mutex>(m_global_quit);
        global_quit = true;
    }
}

////////////////////////////////
// Local function definitions
////////////////////////////////
static bool compare(const char s1[], const char s2[])
{
    return (std::strncmp(s1, s2, std::strlen(s2)) == 0);
}

int command_count(char *cmd_start, int cmd_index, std::string comm_string)
{
    int index = 0;
    const int commword_length = std::strlen(comm_string.c_str());
    for (; index < commword_length; ++index, ++cmd_start, ++cmd_index);
    return index;
}

int whitespace_count(char *cmd_start, int cmd_index)
{
    int index = 0;
    for (index = 0; cmd_index < MAX_CMD_TXT; ++cmd_index, ++cmd_start, ++index) {
        if (is_whitespace(*cmd_start)) {
            continue;
        }
        break;
    }
    return index;
}

int nonwhitespace_count(char *cmd_start, int cmd_index)
{
    int index = 0;
    for (index = 0; cmd_index < MAX_CMD_TXT; ++cmd_index, ++cmd_start, ++index) {
        if (!is_whitespace(*cmd_start)) {
            continue;
        }
        break;
    }
    return index;
}

static bool is_whitespace(const char ch)
{
    return ((ch == ' ') || (ch == '\r')
        || (ch == '\t') || (ch == '\v')
        || (ch == '\f'));
}

static void to_lowercase(char s[], const int len)
{
    for(int i = 0; i < len; ++i) {
        if ((s[i] >= 'A') && (s[i] <= 'Z')) {
            s[i] += 32;
        }
    }
}
