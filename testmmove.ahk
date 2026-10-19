#Include OnMouseMove.ahk
#SingleInstance Force

CoordMode("ToolTip", "Screen")
CoordMode("Mouse", "Screen")

tooltipCb := (x, y, prevX, prevY) => ToolTip(Format("Moved to {1},{2} from {3},{4}", x, y, prevX, prevY), x + 16, y + 16)
OnMouseMove_Start(tooltipCb)

RegionHandler(x, y, prevX, prevY) {
    if (x >= 0 && x <= 50 && y >= 0 && y <= 50) {
        OnMouseMove_Remove(tooltipCb)
        ToolTip()
        MsgBox("You entered the region")
    }
}

OnMouseMove_Start(RegionHandler)