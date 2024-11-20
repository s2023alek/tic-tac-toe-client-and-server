// Project TicTacToe
package t_t.lib {
	
	//{ ======= imports
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	//} ======= END OF import
	
	
	/**
	 * Library contains image BitmapData available through public static properties. Call "initializeLibrary" static method before using Library.
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class Library {
		
		private static const usingLibProcessor:Boolean=false;
		
		//{ ======= EMBED AND PREPARE
		
		//{ ======= ======= templates
		
		//embedding font notice: use additional parameters when encountering errors 
		// fontWeight="bold", fontStyle="italic",
		
		//[Embed(source="../../../res/swfLibs/swf.swf",mimeType="application/octet-stream")]
		//public static const swf:Class;
		
		//[Embed(source="../../../res/images/image0.jpg")]private static const image0_jpg:Class;
		//public static var image0:BitmapData;
		
		//[Embed(source="../../../res/swfLibs/library.swf", symbol="symbol0")]
		//public static const symbol0:Class;
		
		//[Embed(source="../../../res/sounds/sound0.mp3")]
		//public static const sound0:Class;
		
		//[Embed(source='../../../res/fonts/FONT.ttf', fontName="Font", mimeType="application/x-font-truetype")]
		//public static const font0:String;
		
		//[Embed(systemFont='Verdana', fontName="Verdana", mimeType="application/x-font-truetype")] 
		//public static const font_verdana:String; 
		
		//} ======= ======= END OF templates
		
		//[Embed(source="../../../build.txt",mimeType="application/octet-stream")]
		//private static const build_txt:Class;
		public static var build:String="0";
		
		// default picture, do not remove
		//[Embed(source="../../../res/images/mark0.png")]public static const im0_PNG:Class;
		//public static var im0:BitmapData;
		
		[Embed(source="../../../res/images/mark0.png")]public static const mark0:Class;
		public static var im_mark0:BitmapData;
		[Embed(source="../../../res/images/mark1.png")]public static const mark1:Class;
		public static var im_mark1:BitmapData;
		
		public static var im_markNone:BitmapData;

		public static const boardCellMark:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		
		//} ======= END OF EMBED AND PREPARE
		
		
		//{ ======= CONSTRUCTOR
		function Library () {throw(new ArgumentError('Library contains images which are available through public static properties. Invoke "initialize" static method before using Library.'));}
		//} ======= END OF CONSTRUCTOR
		
		
		
		
		/**
		 * prepare library for using
		 */
		public static function initialize(completeRef:Function=null):void{
			completeRef_ = completeRef;
			parseBuildNum();
			
			createBitmaps();
		}
		private static function initialized():void {
			if (completeRef_ != null) {completeRef_();}
		}
		
		private static function parseBuildNum():void {
			//var buildFile:ByteArray = ByteArray(new build_txt());
			//build = buildFile.readUTFBytes(buildFile.length);
		}
		
		
		private static function createBitmaps():void {
			im_mark0 = new mark0().bitmapData;
			im_mark1 = new mark1().bitmapData;
			
			im_markNone = new BitmapData(im_mark0.width, im_mark0.height, false, 0xffffffff);
			
			boardCellMark.push(im_markNone);
			boardCellMark.push(im_mark0);
			boardCellMark.push(im_mark1);
			
			if (!usingLibProcessor) {
				initialized();
				return;
			}
			
			
			new LibProcessor(
				[
					//new lib_swf()
				]
				,[
					// ======== lib_swf ========
					[
					"Symbol0"
					//,"Symbol1"
					]
				]
				,function (a:LibProcessor):void {
					// assign
					var d:Array;
					
					// ======== lib_swf ========
					d = a.get_definitions().shift();
					
					//Symbol0 = d.shift();
					//Symbol1 = d.shift();
					
					// end
					initialized();
				}
			);
			
		}
		
		private static var completeRef_:Function;
		
	}
}


import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

/**
 * attention: no error or exception wrapping(!) pay attention to input.
 * @author Jinanoimatey Dragoncat
 * @version 0.0.0
 */
class LibProcessor {
	
	/**
	 * @param	definitionNames[[String, ...], ...]
	 * @param	libData [ByteArray, ...]
	 * @param	callback (this):void
	 * @param	name
	 */
	public function LibProcessor(libData:Array, definitionNames:Array, callback:Function, name:String=null):void {
		this.definitionNames = definitionNames;
		this.libData = libData;
		this.name = name;
		this.callback = callback;
		
		process_swf();
	}
	
	private function process_swf():void {
		if (libData.length<1) {
			callback(this);
		} else {
			currentLibData = libData.shift();
			currentLibNames = definitionNames.shift();
			loader0 = new Loader();
			loader0.loadBytes(currentLibData, new LoaderContext(false, ApplicationDomain.currentDomain));
			loader0.contentLoaderInfo.addEventListener(Event.COMPLETE, l0);
		}
	}
	
	private function l0 (e:Event):void {
		var d:Array = [];
		for each(var i:String in currentLibNames) {
			d.push(e.target.content.loaderInfo.applicationDomain.getDefinition(i));
		}
		definitions.push(d);
		
		process_swf();
	}
		
	private var loader0:Loader;
		
	/**
	 * [[Class, ...], ...]
	 */
	public function get_definitions():Array {return definitions;}
	
	private var definitions:Array = [];
	private var libData:Array;
	private var currentLibNames:Array;
	private var currentLibData:ByteArray;
	private var name:String;
	private var callback:Function;
	private var definitionNames:Array;
}
