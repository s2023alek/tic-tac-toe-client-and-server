// Project TicTacToe
package  t_t.d.app.i {
	
	//{ ======= import
	//} ======= END OF import
	
	
	/**
	 * unique id
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public interface IDUPlayer extends IDUUID {
		
		function get_markTypeId():int;
		function getDisplayName():String;
	}
}