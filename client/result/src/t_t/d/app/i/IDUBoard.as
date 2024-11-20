// Project TicTacToe
package  t_t.d.app.i {
	
	//{ ======= import
	//} ======= END OF import
	
	
	/**
	 * unique id
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public interface IDUBoard extends IDUUID {
		
		function get_w():int;
		function get_h():int;
		
		function getCellMark(x:int, y:int):IDUBoardMark;
		function get_listCellMarks():Vector.<IDUBoardMark>;

		/**
		 * @return success
		 */
		function setCellMark(a:IDUBoardMark):Boolean;
	}
}