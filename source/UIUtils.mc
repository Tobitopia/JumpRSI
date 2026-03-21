import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

module UIUtils {
    function drawPagination(dc as Dc, currentPage as Number, totalPages as Number) as Void {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var dotRadius = 3;
        var spacing = 12;
        var totalWidth = (totalPages - 1) * spacing;
        var startX = (width - totalWidth) / 2;
        var y = height - 20;

        for (var i = 0; i < totalPages; i++) {
            if (i == currentPage) {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(startX + (i * spacing), y, dotRadius + 1);
            } else {
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(startX + (i * spacing), y, dotRadius);
            }
        }
    }
}
