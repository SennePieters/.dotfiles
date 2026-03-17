const time = Variable('', {
    poll: [1000, function() {
        return Utils.exec('date "+%H:%M:%S %b %e."');
    }],
});

const Bar = (monitor = 0) => Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        start_widget: Widget.Label({
            hpack: 'start',
            label: ' Welcome to AGS!',
        }),
        center_widget: Widget.Label({
            hpack: 'center',
            label: time.bind(),
        }),
        end_widget: Widget.Label({
            hpack: 'end',
            label: 'Dotfiles 🚀 ',
        }),
    }),
});

App.config({
    windows: [Bar(0)],
});