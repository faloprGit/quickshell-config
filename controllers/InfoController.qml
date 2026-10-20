pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Singleton {
    id: root

    property string cpuTemperature: "0°C"
    property int cpuUsagePercent: 0
    property int ramUsagePercent: 0
    property string diskSpeedFormatted: "0 MB/s"

    property int _totalKb: 0
    property int _prevSector: 0
    property real _prevCpuIdle: 0
    property real _prevCpuTotal: 0

    Timer {
        id: refreshTimer
        interval: 2000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            tempProc.running = true
            ramProc.running = true
            diskProc.running = true
            cpuProc.running = true
        }
    }

    Process {
        id: tempProc
        command: ["cat", "/sys/class/thermal/thermal_zone0/temp"]
        stdout: SplitParser {
            onRead: data => {
                if (!Config.useFahrenheit) {
                    root.cpuTemperature = String(Math.round(parseInt(data) / 1000)) + "°C";
                } else {
                    root.cpuTemperature = String(Math.round(((parseInt(data) / 1000) * (9 / 5)) + 32)) + "F";
                }
            }
        }
    }

    Process {
        id: cpuProc
        command: ["cat", "/proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                var match = data.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
                if (match) {
                    var user = parseInt(match[1]);
                    var nice = parseInt(match[2]);
                    var system = parseInt(match[3]);
                    var idle = parseInt(match[4]);
                    var iowait = parseInt(match[5]);
                    var irq = parseInt(match[6]);
                    var softirq = parseInt(match[7]);
                    var steal = parseInt(match[8]);

                    var currentIdle = idle + iowait;
                    var currentTotal = user + nice + system + idle + iowait + irq + softirq + steal;

                    var totalDiff = currentTotal - root._prevCpuTotal;
                    var idleDiff = currentIdle - root._prevCpuIdle;

                    if (totalDiff > 0) {
                        var cpuUsage = (1.0 - (idleDiff / totalDiff)) * 100;
                        root.cpuUsagePercent = Math.round(cpuUsage);
                    }

                    root._prevCpuIdle = currentIdle;
                    root._prevCpuTotal = currentTotal;
                }
            }
        }
    }

    Process {
        id: ramProc
        command: ["cat", "/proc/meminfo"]
        stdout: SplitParser {
            onRead: data => {
                var totalMatch = data.match(/MemTotal:\s+(\d+)\s+kB/);
                var availMatch = data.match(/MemAvailable:\s+(\d+)\s+kB/);

                if (totalMatch) {
                    root._totalKb = parseInt(totalMatch[1]);
                } else if (availMatch && root._totalKb > 0) {
                    var availKb = parseInt(availMatch[1]);
                    var usageKb = root._totalKb - availKb;

                    root.ramUsagePercent = Math.round((usageKb / root._totalKb) * 100);
                }
            }
        }
    }

    Process {
        id: diskProc
        command: ["cat", "/sys/block/nvme0n1/stat"]
        stdout: SplitParser {
            onRead: data => {
                var currentSector = data.match(/^\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);

                if (currentSector) {
                    var curr = parseInt(currentSector[7]);

                    if (root._prevSector > 0) {
                        var sectorsWritten = curr - root._prevSector;

                        // 1 sector = 512 bytes
                        // Bytes to MB = (sectorsWritten * 512) / (1024 * 1024)
                        var bytesWritten = sectorsWritten * 512;
                        var mbWritten = bytesWritten / 1048576;

                        // Divide by timer interval (2 seconds) to get per-second speed
                        var mbPerSec = mbWritten / 2;

                        if (mbPerSec >= 1.0) {
                            root.diskSpeedFormatted = mbPerSec.toFixed(1) + " MB/s";
                        } else {
                            var kbPerSec = (bytesWritten / 1024) / 2;
                            root.diskSpeedFormatted = Math.round(kbPerSec) + " KB/s";
                        }
                    }

                    root._prevSector = curr;
                }
            }
        }
    }
}
