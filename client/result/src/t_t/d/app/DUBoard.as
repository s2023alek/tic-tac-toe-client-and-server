// Project TicTacToe
package  t_t.d.app {
	import t_t.d.app.i.IDUBoard;
	import t_t.d.app.i.IDUBoardMark;
	
	//{ ======= import
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class DUBoard extends DUAbstractUniversal implements IDUBoard {
		
		//{ ======= CONSTRUCTOR
		public function DUBoard (id:String) {
			super(id);
		}
		//} ======= END OF CONSTRUCTOR
		
		public function setCellMark(a:IDUBoardMark):Boolean {
			var x:int = a.get_cx();
			var y:int = a.get_cy();
			
			if (cell[x] == null) { cell[x] = []; }
			if (cell[x][y] == null) {
				cell[x][y] = a; 
				listCellMarks.push(a);
				return true;
			}
			
			return false;
		}
		
		public function get_listCellMarks():Vector.<IDUBoardMark> {
			return listCellMarks.slice();
		}
		private const listCellMarks:Vector.<IDUBoardMark> = new Vector.<IDUBoardMark>;
		
		public function getCellMark(x:int, y:int):IDUBoardMark {
			if (cell[x] == null) { return null;}
			return cell[x][y];
		}
		
		private const cell:Array = [];
		
	}
}