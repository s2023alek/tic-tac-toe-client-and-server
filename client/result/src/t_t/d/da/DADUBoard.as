// Project TicTacToe
package t_t.d.da {
	
	//{ ======= import
	import t_t.d.app.i.IDUBoard;
	
	import t_t.LOG;
	import t_t.LOGGER;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class DADUBoard {
		
		public static function hasLine(target:IDUBoard, markTypeId:int):Boolean {
			// TODO: 
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
			7-"AF"
		* @param	m msg
		* @param	l level
			0-INFO
			1-WARNING
			2-ERROR
		*/
		private static function log(c:uint, m:String, l:uint=0):void {
			LOG(LOGGER.C_OP,m,l);
		}
		
		
	}
}