// Project TicTacToe
package t_t.c.vcm {
	
	//{ ======= import
	
	import flash.geom.Point;
	import t_t.d.app.i.IDUBoard;
	import t_t.media.Text;
	import t_t.v.AVC;
	import t_t.v.VCChat;
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
	public class VCMChat extends AVCM {
		
		//{ ======= CONSTRUCTOR
		
		function VCMChat (app:Application) {
			super(NAME);
			a=app;
		}
		//} ======= END OF CONSTRUCTOR
		
		//{ ======= ======= controll
		
		public override function listen(eventType:String, details:Object):void {
			var m_:JDM = (details as JDM);
			switch (eventType) {
			
			case ID_A_REGISTER_SINGLETON_VC:
				vc = m_.go(0) as VCChat;
				configureVC();
				break;
				
			case ID_A_CHAT_MESSAGE:
				vc.addOutLine(m_.gs(0));
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
		

		private function el_vc(target:VCChat, eventType:String, details:Object = null):void {
			switch (eventType) {
			
			case VCChat.ID_E_PRESSED:
				
				switch (details) {
					case VCChat.ID_B_SEND:
						var m_:JDM = JDM.getInstance();
						m_.ss(0, vc.getInputText());
						e.listen(ID_E_CHAT_MSG, m_);
						m_.freeInstance();
						break;
				}
				
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
		
		//{ ======= events
		
		/**
		 * send message {String}
		 */
		public static const ID_E_CHAT_MSG:String = NAME + '>ID_E_CHAT_MSG';
		
		//} ======= END OF events
		
		//} ======= ======= END OF id
		
		public override function autoSubscribeEvents(envName:String):Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_CHAT_MESSAGE
			];
		}
		
		
		/**
		 * display message {String}
		 */
		public static const ID_A_CHAT_MESSAGE:String = NAME+'ID_A_CHAT_MESSAGE';
		
		
		public static const NAME:String = 'VCMChat';
		
		
		
				
		//{ ======= private 
		private var vc:VCChat;
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