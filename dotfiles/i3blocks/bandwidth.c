#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <dirent.h>

// Find active network interface
int find_active_interface(char *interface, size_t len) {
    DIR *dir = opendir("/sys/class/net");
    if (!dir) return 0;
    
    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        // Skip loopback and special entries
        if (strcmp(entry->d_name, ".") == 0 || 
            strcmp(entry->d_name, "..") == 0 ||
            strcmp(entry->d_name, "lo") == 0) {
            continue;
        }
        
        // Check if interface is UP
        char path[256];
        snprintf(path, sizeof(path), "/sys/class/net/%s/operstate", entry->d_name);
        
        FILE *f = fopen(path, "r");
        if (f) {
            char state[16];
            fgets(state, sizeof(state), f);
            fclose(f);
            
            // Found active interface
            if (strncmp(state, "up", 2) == 0) {
                strncpy(interface, entry->d_name, len);
                closedir(dir);
                return 1;
            }
        }
    }
    
    closedir(dir);
    return 0;
}

// Read bytes from file
long long read_bytes(const char *interface, const char *stat) {
    char path[256];
    snprintf(path, sizeof(path), "/sys/class/net/%s/statistics/%s", interface, stat);
    
    FILE *f = fopen(path, "r");
    if (!f) {
        fprintf(stderr, "Error: Cannot read %s (interface '%s' not found?)\n", path, interface);
        return -1;
    }
    
    long long bytes;
    fscanf(f, "%lld", &bytes);
    fclose(f);
    return bytes;
}

// Format speed with units
void format_speed(double speed_kb, char *output) {
    if (speed_kb > 1024.0) {
        sprintf(output, "%.1f MB/s", speed_kb / 1024.0);
    } else {
        sprintf(output, "%.1f KB/s", speed_kb);
    }
}

int main(int argc, char *argv[]) {
    char interface[64];
    
    if (argc == 2) {
        // Use provided interface
        strncpy(interface, argv[1], sizeof(interface));
    } else {
        // Auto-detect active interface
        if (!find_active_interface(interface, sizeof(interface))) {
            fprintf(stderr, "Error: No active network interface found\n");
            return 1;
        }
    }
    
    // First measurement
    long long rx1 = read_bytes(interface, "rx_bytes");
    long long tx1 = read_bytes(interface, "tx_bytes");
    
    if (rx1 < 0 || tx1 < 0) {
        return 1;
    }
    
    // Wait 1 second
    sleep(1);
    
    // Second measurement
    long long rx2 = read_bytes(interface, "rx_bytes");
    long long tx2 = read_bytes(interface, "tx_bytes");
    
    if (rx2 < 0 || tx2 < 0) {
        return 1;
    }
    
    // Calculate speed in KB/s
    double rx_speed = (rx2 - rx1) / 1024.0;
    double tx_speed = (tx2 - tx1) / 1024.0;
    
    // Format output
    char rx_str[32], tx_str[32];
    format_speed(rx_speed, rx_str);
    format_speed(tx_speed, tx_str);
    
    // Print result
    printf("↓ %s ↑ %s\n", rx_str, tx_str);
    
    return 0;
}
