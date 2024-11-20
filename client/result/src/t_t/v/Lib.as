// Project TicTacToe
package t_t.v {
	
	//{ ======= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import org.aswing.AssetIcon;
	import org.aswing.JButton;
	import org.aswing.JToggleButton;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * 
	 */
	public class Lib {
		
		public static function modifyIconifiedButton(target:JButton, icons:Array):void {
			target.setIcon(new AssetIcon(icons[0]));
			target.setRollOverIcon(new AssetIcon(icons[1]));
			target.setPressedIcon(new AssetIcon(icons[2]));
		}
		
		public static function createIconifiedToggleButton(id:String, listener:Function, text:String, icons:Array, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null):JButton {
			var sb:JButton=createIconifiedButton(id, listener, text,icons,fixH,fixW,textHint);
			sb.setSelectedIcon(new AssetIcon(icons[2]));
			sb.setRollOverSelectedIcon(new AssetIcon(icons[2]));
			sb.cacheAsBitmap = true;
			return sb;
		}
		
		public static function createIconifiedButton(id:String, listener:Function, text:String, icons:Array, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null):JButton {
			var sb:JButton=new JButton(text, new AssetIcon(icons[0]));
			sb.setRollOverIcon(new AssetIcon(icons[1]));
			sb.setPressedIcon(new AssetIcon(icons[2]));
			
			sb.name=id;
			sb.addActionListener(listener);sb.pack();
			if (fixH) {sb.setMaximumHeight(sb.getHeight());}
			if (fixW) {sb.setMaximumWidth(sb.getWidth());}
			if (textHint) {sb.setToolTipText(textHint);}
			sb.setOpaque(false);
			sb.setBackgroundDecorator(null);
			sb.cacheAsBitmap = true;
			return sb;
		}
		
		public static function createWindowTitleIcon(iconImage:DisplayObject, borderWidth:int = 1, resizeToW:int = 27, resizeToH:int = 27):DisplayObject {
			return createIcon(iconImage, borderWidth, resizeToW, resizeToH);
		}
		public static function createIcon(iconImage:DisplayObject, borderWidth:int = 1, resizeToW:int = 32, resizeToH:int = 32, cacheAsBitmap:Boolean=true):DisplayObject {
			var sp:Sprite;
			iconImage.cacheAsBitmap = cacheAsBitmap;
			iconImage.x = borderWidth;iconImage.y = borderWidth;
			if (resizeToW > 0) {iconImage.width = resizeToW;iconImage.height = resizeToH;}
			sp = new Sprite; sp.addChild(iconImage);
			sp.cacheAsBitmap = true;
			sp.graphics.beginFill(0, 0);
			sp.graphics.drawRect(0, 0, borderWidth * 2 + iconImage.width, borderWidth * 2 + iconImage.height);
			var i:DisplayObject = iconImage;
			if (i is Bitmap) {
				Bitmap(i).pixelSnapping = PixelSnapping.ALWAYS;Bitmap(i).smoothing = true;
			} else {
				for each(var ii:DisplayObject in i) {
					if (ii is Bitmap) {
						Bitmap(ii).pixelSnapping = PixelSnapping.ALWAYS;Bitmap(ii).smoothing = true;
					}
				}
			}
			//sp.x = borderWidth; sp.y = borderWidth;
			return sp;
		}
		public static function modifyIconAndButton(target:JButton, icons:Array):void {
			target.setIcon(new AssetIcon(createIcon(icons[0])));
			target.setRollOverIcon(new AssetIcon(createIcon(icons[1])));
			target.setPressedIcon(new AssetIcon(createIcon(icons[2])));
		}
		
		
		public static function createIconAndButton(id:String, listener:Function, text:String, iconImages:Array, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null, borderWidth:int=1, resizeToW:int=32, resizeToH:int=32, cacheAsBitmap:Boolean=true):JButton {
			var icons:Array=[];//display object
			var effectsAlpha:Array = [.8, 1, .6];
			for each(var i:DisplayObject in iconImages) {
				i = createIcon(i, borderWidth, resizeToW,resizeToH, cacheAsBitmap);
				i.alpha=effectsAlpha.shift();
				icons.push(i);
			}
			var sb:JButton=new JButton(text, new AssetIcon(icons[0]));
			sb.setRollOverIcon(new AssetIcon(icons[1]));
			sb.setPressedIcon(new AssetIcon(icons[2]));
			
			sb.name=id;
			sb.addActionListener(listener);sb.pack();
			if (fixH) {sb.setMaximumHeight(sb.getHeight());}
			if (fixW) {sb.setMaximumWidth(sb.getWidth());}
			if (textHint) {sb.setToolTipText(textHint);}
			//sb.setOpaque(false);
			//sb.setBackgroundDecorator(null);
			
			return sb;
		}
		
		public static function createSimpleButton(id:String, listener:Function, text:String, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null):JButton {
			var sb:JButton=new JButton(text);
			sb.name=id;sb.addActionListener(listener);sb.pack();
			if (fixH) {sb.setMaximumHeight(sb.getHeight());}if (fixW) {sb.setMaximumWidth(sb.getWidth());}
			if (textHint) {sb.setToolTipText(textHint);}
			return sb;
		}
		
	}
}