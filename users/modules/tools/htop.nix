{
  programs.htop = {
    enable = true;
    settings = {
      delay = 10;
      left_meters = [ "AllCPUs2" "Memory" "Swap" ];
      right_meters = [ "Clock" "Hostname" "Tasks" "LoadAverage" "Uptime" "Battery" ];
    };
  };
}
