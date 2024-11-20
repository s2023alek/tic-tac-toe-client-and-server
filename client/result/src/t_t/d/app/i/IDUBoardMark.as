// Project TicTacToe
package  t_t.d.app.i {
	
	//{ ======= import
	//} ======= END OF import
	
	
	/**
	 * unique id
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public interface IDUBoardMark extends IDUUID {
		
		function get_pid():String;
		function get_cx():int;
		function get_cy():int;
	}
}