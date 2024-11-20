// Project TicTacToe
package t_t.v {
	
	//{ ===== import
	import flash.geom.Point;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.JPopup;
	import org.aswing.border.EmptyBorder;
	import t_t.APP;
	import t_t.d.app.DUMarkType;
	import t_t.lib.Library;
	import t_t.media.Text;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import t_t.LOG;
	import t_t.LOGGER;

	//} ===== END OF import
	
	
	
	/**
	 * main app window
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class VCGameBoard extends AVC {
		
		//{ ===== CONSTRUCTOR
		
		function VCGameBoard (reduceHeighWebVersion:int) {
			this.reduceHeighWebVersion = reduceHeighWebVersion;
			prepareContainer();
			
			dispatchEvent(AVC.ID_E_INTERFACE_ACCESSIBLE);
		}
		
		//} ===== END OF CONSTRUCTOR
		
		
		//{ ===== ===== user access
		
		public function getCell(x:uint, y:uint):VCGBCell {
			return cells[x][y];
		}
		
		public function redrawGrid(gw:uint, gh:uint):void {
			if (list_cells.length>0) {
				LOG(0, 'game board can only be drawn once in this(offline) version', 1);
				for each(var j:VCGBCell in list_cells) {j.switchMark(DUMarkType.ID_NONE);}
				return;
			}
			
			var row:JPanel;
			var bitem:VCGBCell;
			for (var i:int = 0; i < gh; i++) {
				row = new JPanel(new BoxLayout(BoxLayout.X_AXIS, 5));
				cells[i] = [];
				for (var u:int = 0; u < gw; u++) {
					bitem = new VCGBCell(i, u, el_boardCell);
					bitem.setResources(Library.boardCellMark);
					bitem.switchMark(0);
					row.append(bitem);
					cells[i][u] = bitem;
					list_cells.push(bitem);
				}
				column.append(row);
			}
			vc.pack();
		}

		
		public function orderLayers():void {
			container.addChild(vc);
		}
		 
		public function repositionComponents():void {
			container.stage.addEventListener(Event.ENTER_FRAME, function (e:Event):void {//TODO: bug below listener not removed
				container.removeEventListener(e.type, arguments.callee);
				positionComponents();
			} );
		}
		
		public function positionComponents():void {
			if (!container || !container.stage) {return; } 
			orderLayers();
		}
		
		
		//} ======= ======= END OF user access
		
		
		private function addSomeInterface():void {
			//vc = new JPopup(container);
			//vc.setLayout(new BorderLayout());
		}
		

		private function el_boardCell(x:int, y:int):void {
			dispatchEvent(ID_E_PRESSED, new Point(x,y));
		}
		
		
		
		private var column:JPanel;
		private var reduceHeighWebVersion:int;
		private var vc:JPopup;
		private var rows:Vector.<JPanel> = new Vector.<JPanel>;
		private var cells:Array = [];//[][]
		private var list_cells:Vector.<VCGBCell>=new Vector.<VCGBCell>;
		
		
		//{ ======= container
		private function prepareContainer():void {
			container = new Sprite();
			vc = new JPopup(container);
			vc.setLayout(new BorderLayout());
		
			column = new JPanel(new BoxLayout(BoxLayout.Y_AXIS, 5));
			vc.append(column, BorderLayout.CENTER);
			
			vc.show();
		
			if (!container.stage) {container.addEventListener(Event.ADDED_TO_STAGE, el_addedToStage);} else {el_addedToStage();};
		}
		private function el_addedToStage(e:Event = null):void {
			//container.removeEventListener(e.type, el_addedToStage);
			if (addedToStageAtleastOnce) { el_StageResize(); return; }
			
			addedToStageAtleastOnce = true;
			container.stage.addEventListener(Event.RESIZE, el_StageResize);
			addSomeInterface();
			el_StageResize();
		}
		private var addedToStageAtleastOnce:Boolean;
		

		private function el_StageResize(e:Event = null):void { if (!vc.stage) { return;}
			//log(3, 'screen resolution changed:'+AppCfg.appScreenW+'x'+AppCfg.appScreenH);
			positionComponents();
			resizeVC();
		}


		private function resizeVC():void {
			w = vc.stage.stageWidth;
			h = vc.stage.stageHeight *(1-AVC.get_consoleHM())-reduceHeighWebVersion;
			vc.setSizeWH(w, h);
			vc.setBorder(new EmptyBorder(null, new Insets(h / 20, w / 20, h / 20, w / 20)));
			vc.pack();
		}
		
		//} ======= END OF container
		
		
		//{ ======= events id 
		/**
		 * flash.geom.Point
		 */
		public static const ID_E_PRESSED:String = '>ID_E_PRESSED';
		//} ======= END OF events id
		
		
		
		
		/**
		* @param	c channel id(see LOGGER)
			0-"R"
			1-"DT"
			2-"DS"
			3-"V"
			4-"OP"
			5-"NET"
			6-"AG"
		* @param	m msg
		* @param	l level
			0-INFO
			1-WARNING
			2-ERROR
		*/
		private static function log(c:uint, m:String, l:uint=0):void {
			LOG(c,NAME+'>'+m,l);
		}
		
		
		
		public static const NAME:String = 'VCGameBoard';
		
	}
}