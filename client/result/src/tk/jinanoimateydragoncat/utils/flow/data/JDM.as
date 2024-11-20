package tk.jinanoimateydragoncat.utils.flow.data {
	
	//{ ======= import
	import flash.utils.Dictionary;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * 
	 */
	public class JDM implements IAM {
		
		//{ ======= CONSTRUCTOR
		public function JDM (useStaticMethodInsteadOfConstrctor:String) {
			if (useStaticMethodInsteadOfConstrctor!=PROTECTION_KEY) {throw new ArgumentError('object pool - use static method instead of constrctor');}
			i=[];
			s=[];
			b=[];
			o=[];
		}
		
		protected function clearState():void {
			i.splice(0, i.length);// NOTE: replace .length with more faster solution
			s.splice(0, i.length);// NOTE: replace .length with more faster solution
			b.splice(0, i.length);// NOTE: replace .length with more faster solution
			o.splice(0, o.length);// NOTE: replace .length with more faster solution
		}
		/**
		 * return instance to pool
		 */
		public function freeInstance():void {
			if (f) {return;}
			r(this);//return to the object pool
		}
		//} ======= END OF CONSTRUCTOR
		
		public function gi(i:int):int {return this.i[i];}
		public function si(i:int, a:int):void {this.i[i] = a;}
		public function gs(i:int):String {return s[i];}
		public function ss(i:int, a:String):void {s[i] = a;}
		public function gb(i:int):Boolean {return b[i];}
		public function sb(i:int, a:Boolean):void {b[i] = a;}
		public function go(i:int):Object {return o[i];}
		public function so(i:int, a:Object):void {o[i] = a;}
		
		private var i:Array;
		private var s:Array;
		private var b:Array;
		private var o:Array;
		
		/**
		 * isFree
		 */
		private var f:Boolean;
		
		
		//{ ======= ======= ObjectPool
		/**
		 * getInstance
		 */
		public static function getInstance():JDM {
			var i:JDM=pool[JDM];
			if (!i) {i=new JDM(PROTECTION_KEY);}
			
			var cd:Dictionary=poolNext[JDM];
			if (!cd) {
				cd=new Dictionary();
				poolNext[JDM]=cd;
			}
			
			pool[JDM]=cd[i];
			cd[i]=null;
			
			i.clearState();
			i.f = false;
			return i;
		}
		
		/**
		 * returnInstance
		 */
		private static function r(i:JDM):void {
			var c:Class=JDM;
			
			var cd:Dictionary=poolNext[c];
			if (!cd) {
				cd=new Dictionary();
				poolNext[c]=cd;
			}
			cd[i]=pool[c];
			pool[c]=i;
			i.f = true;
		}
		
		/**
		 * d[classname]d[instance]=*
		 */
		private static var pool:Dictionary=new Dictionary();
		/**
		 * d[classname]=*
		 */
		private static var poolNext:Dictionary=new Dictionary();
		//} ======= ======= END OF ObjectPool		
		
		
		private static const PROTECTION_KEY:String='PROTECTION_KEY';
		
	}
}