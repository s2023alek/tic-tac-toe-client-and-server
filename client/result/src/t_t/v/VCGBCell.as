// Project TicTacToe
package t_t.v {
	
	//{ ======= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.AssetIcon;
	import org.aswing.BorderLayout;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import t_t.lib.Library;
	import t_t.v.Lib;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class VCGBCell extends JPanel {
		
		//{ ======= CONSTRUCTOR
		
		public function VCGBCell (x:uint, y:uint, eventsPipe:Function) {
			this.cx = x; this.cy = y;
			this.eventsPipe = eventsPipe;
			setLayout(new BorderLayout(0, 0));
			
			bbitmap = new Bitmap(Library.im_mark0);
			bIcon = new AssetIcon(bbitmap);
			
			button0 = new JButton('', bIcon);
			button0.addActionListener(el_b);
			append(button0, BorderLayout.CENTER);
		}
		public function destroy():void {
			eventsPipe = null;
			button0.removeActionListener(el_b);
			button0 = null;
			bbitmap.bitmapData = null;
			bIcon = null;
		}
		//} ======= END OF CONSTRUCTOR
		
		
		
		
		
		public function setResources(list_marksBD:Vector.<BitmapData>):void {
			this.list_marksBD = list_marksBD;
		}		
		
		
		public function switchMark(sn:uint):void {
			bbitmap.bitmapData = list_marksBD[sn];
			//pack();
			//repaintAndRevalidate();
		}
		
		private function el_b(e:Event):void {
			eventsPipe(cx, cy);
		}
		
		private var list_marksBD:Vector.<BitmapData>;
		private var eventsPipe:Function;
		private var cx:uint;
		private var cy:uint;
		private var button0:JButton;
	
	
		private var bbitmap:Bitmap;
		private var bIcon:AssetIcon;
			
		
	}
}