import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

module UIUtils {
    function drawPagination(dc as Dc, currentPage as Number, totalPages as Number) as Void {
        var height = dc.getHeight();
        var dotRadius = 3;
        var spacing = 12;
        var totalHeight = (totalPages - 1) * spacing;
        var x = 15; // Left side
        var startY = (height - totalHeight) / 2;

        for (var i = 0; i < totalPages; i++) {
            if (i == currentPage) {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(x, startY + (i * spacing), dotRadius + 1);
            } else {
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(x, startY + (i * spacing), dotRadius);
            }
        }
    }
}
