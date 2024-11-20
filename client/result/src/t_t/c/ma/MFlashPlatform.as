// Project TicTacToe
package t_t.c.ma {
	
	//{ ======= import
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.system.fscommand;
	import t_t.Application;
	import t_t.c.ae.AEApp;
	import t_t.LOG;
	import t_t.LOGGER;
	import tk.jinanoimateydragoncat.utils.flow.data.IAM;
	import tk.jinanoimateydragoncat.utils.flow.data.JDM;
	//} ======= END OF import
	
	
	/**
	 * provides access to specific non-essential flash platform functionality
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class MFlashPlatform extends AM {
		
		//{ ======= CONSTRUCTOR
		
		function MFlashPlatform (app:Application) {
			super(NAME);
			a = app;
			
			a.get_Screen().get_screenMain().get_displayObject().stage.addEventListener(Event.FULLSCREEN, ev_FULLSCREEN);
		}
		//} ======= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			switch (eventType) {
			
			case ID_A_TOGGLE_FULLSCREEN:
				var s:Stage=a.get_Screen().get_screenMain().get_displayObject().stage;
				if (!s) {log(3, 'ID_A_TOGGLE_FULLSCREEN>stage is null',1);break;}
				try {
					s.displayState = ((s.displayState == StageDisplayState.NORMAL)?StageDisplayState.FULL_SCREEN:StageDisplayState.NORMAL);
				} catch (e:Error) {}
				break;
			
			case ID_A_EXIT:
				fscommand("quit");
				break;
				
			case ID_A_LOAD_FILE:
				loadJsonFile((details as JDM).gs(0));
				break;
			
			}
		}
		
		private function ev_FULLSCREEN(e:Event):void {
			a.get_ae().listen((a.get_Screen().get_screenMain().get_displayObject().stage.displayState == StageDisplayState.NORMAL)?ID_E_NORMALSCREEN:ID_E_FULLSCREEN, null);
		}
		
		private function loadJsonFile(eventName:String):void {
			log(LOGGER.C_NET, 'Load file>select file with app DB data');
			var fr:FileReference=new FileReference();
			fr.addEventListener(Event.SELECT, function(e:Object):void {
				log(LOGGER.C_NET, 'Load file>Loading');
				fr.load();
			});
			fr.addEventListener(Event.CANCEL, function(e:Object):void {log(LOGGER.C_NET,'cancel button pressed');});
			fr.addEventListener(Event.COMPLETE, function(e:Object):void {
					log(5, 'Load file>Loaded');
					var m:JDM = JDM.getInstance();
					m.ss(0, eventName);
					m.ss(1, fr.data.toString());
					a.get_ae().listen(ID_E_FILE_DATA_LOADED, m);
					m.freeInstance();
				}
			);
			fr.browse([new FileFilter('*', '*')]);	
		}

		
		//{ ======= actions
		
		/**
		 * string:file(session) id
		 */
		public static const ID_A_LOAD_FILE:String=NAME+'ID_A_LOAD_FILE';
		public static const ID_A_EXIT:String=NAME+'ID_A_EXIT';
		public static const ID_A_TOGGLE_FULLSCREEN:String=NAME+'ID_A_TOGGLE_FULLSCREEN';
		//} ======= END OF actions
		
		//{ ======= events
		public static const ID_E_FULLSCREEN:String = NAME+"ID_E_FULLSCREEN";
		public static const ID_E_NORMALSCREEN:String = NAME + "ID_E_NORMALSCREEN";
		/**
		 * string 0: provided file(session) id
		 * string 1: file contents
		 */
		public static const ID_E_FILE_DATA_LOADED:String = NAME+"ID_E_FILE_DATA_LOADED";
		//} ======= END OF events
		
		
		
		public static const NAME:String = 'MFlashPlatform';
		
		public override function autoSubscribeEvents(envName:String):Array {
			return [
				ID_A_TOGGLE_FULLSCREEN
				,ID_A_LOAD_FILE
				,ID_A_EXIT
			];
		}
		
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