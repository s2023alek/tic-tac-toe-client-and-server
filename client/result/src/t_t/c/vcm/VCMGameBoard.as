// Project TicTacToe
package t_t.c.vcm {
	
	//{ ======= import
	
	import flash.geom.Point;
	import t_t.d.app.i.IDUBoard;
	import t_t.media.Text;
	import t_t.v.AVC;
	import t_t.v.VCGameBoard;
	
	import t_t.c.ae.AEApp;
	
	import t_t.APP;
	import t_t.Application;
	
	import t_t.LOG;
	import t_t.LOGGER;
	
	
	import tk.jinanoimateydragoncat.utils.flow.data.IAM;
	import tk.jinanoimateydragoncat.utils.flow.data.JDM;
	//} ======= END OF import
	
	/**
	 * display manager - controlls main interface
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class VCMGameBoard extends AVCM {
		
		//{ ======= CONSTRUCTOR
		
		function VCMGameBoard (app:Application) {
			super(NAME);
			a=app;
		}
		//} ======= END OF CONSTRUCTOR
		
		//{ ======= ======= controll
		
		public override function listen(eventType:String, details:Object):void {
			var m_:JDM = (details as JDM);
			switch (eventType) {
			
			case ID_A_REGISTER_SINGLETON_VC:
				vc = m_.go(0) as VCGameBoard;
				configureVC();
				break;
				
			case ID_A_REDRAW_BOARD:
				//get board from DS by id
				var bd:IDUBoard = a.get_appData().get_gameSession().get_board();
				vc.redrawGrid(bd.get_w(), bd.get_h());
				break;
				
			case ID_A_CLEAR_BOARD:
				//get board from DS by id
				vc.redrawGrid(details.w, details.h);
				break;
				
			case ID_A_SET_CELL_MARK:
				if (m_) {
					vc.getCell(m_.gi(0), m_.gi(1)).switchMark(m_.gi(3));
				} else {
					//log(LOGGER.C_OP, 'ID_A_SET_CELL_MARK: x,y,sn= ' + [details.x, details.y, details.markSN].join("/"));
					vc.getCell(details.x, details.y).switchMark(details.markSN);
				}
				break;
			
			case ID_A_LOAD_BOARD_DATA:
				var boardData:Array = details as Array;
				var sn:int = 0;
				for (var i:int = 0; i < 3; i++) {
					for (var ii:int = 0; ii < 3; ii++) {
						vc.getCell(i, ii).switchMark(boardData[sn]);
						sn += 1;
					}
				}
				break;
				
			}
			
			if (m_) {m_.freeInstance();}
		}
		
		private function configureVC():void {
			configureControll();
		}
		
		private function configureControll():void {
			vc.setListener(el_vc);
		}
		

		private function el_vc(target:VCGameBoard, eventType:String, details:Object = null):void {
			switch (eventType) {
			
			case VCGameBoard.ID_E_PRESSED:
				//var m_:JDM = JDM.getInstance();
				
				var cp:Point = details as Point;
				//m_.si(0, cp.x);m_.si(1, cp.y);
				
				e.listen(ID_E_CELL_SELECTED, {x:cp.x, y:cp.y});
				//m_.freeInstance();
				break;
				
			case AVC.ID_E_INTERFACE_ACCESSIBLE:
				//nothing 2do here
				break;
			
			}
		}
		
		//} ======= ======= END OF controll
		
		
		//{ ======= private 
		//} ======= END OF private
		
		
		//{ ======= ======= id
		/**
		 * data:VCMainScreen
		 */
		public static const ID_A_REGISTER_SINGLETON_VC:String = NAME + '>ID_A_REGISTER_SINGLETON_VC';
		/**
		 * String: boardId(online version only)
		 */
		public static const ID_A_REDRAW_BOARD:String = NAME + '>ID_A_REDRAW_BOARD';
		/**
		 * {w:int, h:int)
		 */
		public static const ID_A_CLEAR_BOARD:String = NAME + '>ID_A_CLEAR_BOARD';
		/**
		 * int:x, y, markSN
		 */
		public static const ID_A_SET_CELL_MARK:String = NAME + '>ID_A_SET_CELL_MARK';
		public static const ID_A_LOAD_BOARD_DATA:String = NAME + '>ID_A_LOAD_BOARD_DATA';
		
		//{ ======= events
		
		/**
		 * int:x,y
		 */
		public static const ID_E_CELL_SELECTED:String = NAME + '>ID_E_CELL_SELECTED';
		
		//} ======= END OF events
		
		//} ======= ======= END OF id
		
		public override function autoSubscribeEvents(envName:String):Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_REDRAW_BOARD
				,ID_A_CLEAR_BOARD
				,ID_A_SET_CELL_MARK
				,ID_A_LOAD_BOARD_DATA
			];
		}
		
		public static const NAME:String = 'VCMGameBoard';
		
		
				
		//{ ======= private 
		private var vc:VCGameBoard;
		//} ======= END OF private
		
		
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
		
		
	}
}