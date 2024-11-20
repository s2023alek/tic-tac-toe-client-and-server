// Project TicTacToe
package  t_t.d.app {
	
	//{ ======= import
	//} ======= END OF import
	
	
	/**
	 * при текущим требованиям к проекту, подобный расход памяти допустим. при необходимости можно сделать несколько экономичных классов благодаря использованию интерфейсов
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class DUAbstractUniversal {
		
		//{ ======= CONSTRUCTOR
		public function DUAbstractUniversal (id:String=null, pid:String=null, cx:int=0, cy:int=0, markTypeId:int=0, w:int=3, h:int=3, displayName:String=null) {
			this.id = id;
			this.pid = pid;
			this.cx = cx;
			this.cy = cy;
			this.w = w;
			this.h = h;
			this.mtid = markTypeId;
			this.displayName = displayName;
		}
		//} ======= END OF CONSTRUCTOR
		
		public function get_id():String { return id; }
		/**
		 * player id
		 */
		public function get_pid():String {return pid;}
		public function get_cx():int {return cx;}
		public function get_cy():int { return cy; }
	
		public function get_w():int { return w;}
		public function get_h():int { return h;}
		
		public function get_markTypeId():int {return mtid;}
		public function getDisplayName():String { return displayName;}

		protected var displayName:String;
		protected var id:String;
		protected var pid:String;
		protected var w:int;
		protected var h:int;
		protected var cy:int;
		protected var cx:int;
		protected var mtid:int;
		
	}
}