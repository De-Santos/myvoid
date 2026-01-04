#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

typedef struct {
    long long user, nice, system, idle;
} CPUStat;

// Read CPU stats from /proc/stat
void read_cpu_stat(CPUStat *stat) {
    FILE *f = fopen("/proc/stat", "r");
    if (!f) {
        perror("fopen");
        exit(1);
    }
    
    fscanf(f, "cpu %lld %lld %lld %lld", 
           &stat->user, &stat->nice, &stat->system, &stat->idle);
    fclose(f);
}

int main() {
    CPUStat stat1, stat2;
    
    // First measurement
    read_cpu_stat(&stat1);
    
    // Wait 1 second
    sleep(1);
    
    // Second measurement
    read_cpu_stat(&stat2);
    
    // Calculate differences
    long long user_diff = stat2.user - stat1.user;
    long long nice_diff = stat2.nice - stat1.nice;
    long long system_diff = stat2.system - stat1.system;
    long long idle_diff = stat2.idle - stat1.idle;
    
    // Calculate usage
    long long total = user_diff + nice_diff + system_diff + idle_diff;
    double usage = 100.0 * (total - idle_diff) / total;
    
    printf("%.1f%%\n", usage);
    
    return 0;
}
