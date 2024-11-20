// Project TicTacToe
package t_t.v {
	
	//{ ======= import
	import flash.events.Event;
	import org.aswing.ASFont;
	import org.aswing.BorderLayout;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import t_t.v.Lib;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class VCSimpleButton extends JPanel {
		
		//{ ======= CONSTRUCTOR
		
		public function VCSimpleButton (id_:int, eventsPipe:Function, displayName:String) {
			this.id = id_;
			this.eventsPipe = eventsPipe;
			setLayout(new BorderLayout(35, 1));
			button0 = Lib.createSimpleButton('actionB_' + id_, el_b, displayName, false, false);
			button0.setFont(new ASFont("Tahoma", 26, true));
			append(button0, BorderLayout.CENTER);
		}
		public function destroy():void {
			eventsPipe = null;
			button0.removeActionListener(el_b);
			button0 = null;
		}
		//} ======= END OF CONSTRUCTOR
		
		
		private function el_b(e:Event):void {
			eventsPipe(id);
		}
		public function get_id():int {return id;}
		
		private var eventsPipe:Function;
		private var id:int;
		private var button0:JButton;
	
	}
}