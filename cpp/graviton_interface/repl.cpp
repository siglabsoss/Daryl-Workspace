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
    POLLSTATS_ID
};

////////////////////////////////
// Local function declarations
////////////////////////////////
//static bool compare(const char s1[], const char s2[]);
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
    const std::string exit_command {"exit"}; // exit (synonym for quit)
    const std::string txmagic_command = {"txmagic"}; // Send TX magic sample
    const std::string rxmagic_command = {"rxmagic"}; // Send RX magic sample
    const std::string send_command = {"send"}; // Send a sine wave, zeros, random sequence, etc.
    const std::string pollstats_command = {"pollstats"}; // Poll link statistics

    // Map of strings to IDs
    std::map<std::string, cmd_id_t> commands;
    commands.insert(std::pair<std::string, cmd_id_t>(help_command, HELP_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(quit_command, QUIT_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(exit_command, QUIT_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(txmagic_command, TXMAGIC_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(rxmagic_command, RXMAGIC_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(send_command, SEND_ID));
    commands.insert(std::pair<std::string, cmd_id_t>(pollstats_command, POLLSTATS_ID));

    // Help string definitions
    const std::string help_help {"displays a list of commands; help <command> : lists help about a command"};
    const std::string help_quit {"exits the program; exit : also exits the program"};
    const std::string help_txmagic {"sends txmagic to graviton"};
    const std::string help_rxmagic {"sends rxmagic to graviton"};
    const std::string help_send {"sends signal to graviton"};
    const std::string help_pollstats {"polls stats of link to graviton"};

    // Map of help strings
    std::map<std::string, std::string> help_strings;
    help_strings.insert(std::pair<std::string, std::string>(help_command, help_help));
    help_strings.insert(std::pair<std::string, std::string>(quit_command, help_quit));
    help_strings.insert(std::pair<std::string, std::string>(txmagic_command, help_txmagic));
    help_strings.insert(std::pair<std::string, std::string>(rxmagic_command, help_rxmagic));
    help_strings.insert(std::pair<std::string, std::string>(send_command, help_send));
    help_strings.insert(std::pair<std::string, std::string>(pollstats_command, help_pollstats));

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
                const int commword_length = std::strlen(help_command.c_str());
                for (auto i = 0; i < commword_length; ++i, ++cmd_start, ++cmd_index);
                // skip whitespace
                for (; cmd_index < MAX_CMD_TXT; ++cmd_index, ++cmd_start) {
                    if (is_whitespace(*cmd_start)) {
                        continue;
                    }
                    break;
                }
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
                // TODO: make this work
                std::cout << "Sending TX Magic" << std::endl;
                std::cout << std::endl;
                std::cerr << "TXMAGIC_ID not yet implemented..." << std::endl;
                break;
            }
            case RXMAGIC_ID: {
                // TODO: make this work
                std::cout << "Sending RX Magic" << std::endl;
                std::cout << std::endl;
                std::cerr << "RXMAGIC_ID not yet implemented..." << std::endl;
                break;
            }
            case SEND_ID: {
                // TODO: make this work
                std::cout << "Sending Signal (sine,rand,etc)" << std::endl;
                std::cout << std::endl;
                std::cerr << "SEND_ID not yet implemented..." << std::endl;
                break;
            }
            case POLLSTATS_ID: {
                // TODO: make this work
                std::cout << "Polling Link Statistics" << std::endl;
                std::cout << std::endl;
                std::cerr << "POLLSTATS_ID not yet implemented..." << std::endl;
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
// static bool compare(const char s1[], const char s2[])
// {
//     return (std::strncmp(s1, s2, std::strlen(s2)) == 0);
// }

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
