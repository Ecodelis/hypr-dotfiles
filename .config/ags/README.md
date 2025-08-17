Usage:
```
ags [command]
```

Available Commands:
```
run         Run an app
request     Send a request to an instance
list        List running instances
inspect     Open up Gtk debug tool
toggle      Toggle visibility of a Window
quit        Quit an instance
types       Generate TypeScript types
bundle      Bundle an app
init        Initialize a project directory
help        Help about any command
```

Force AGS to run the GDK backend set to Wayland
```bash
env GDK_BACKEND=wayland ags run
```
