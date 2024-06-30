const hyprland = await Service.import("hyprland");

export const Workspaces = () => {
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = hyprland.bind("workspaces").as((ws) =>
    ws
      .sort(({ id: a }, { id: b }) => a - b)
      .map(({ id }) =>
        Widget.Button({
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Label(`${id}`),
          class_name: activeId.as((i) => `${i === id ? "focused" : ""}`),
        })
      )
  );

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
};
