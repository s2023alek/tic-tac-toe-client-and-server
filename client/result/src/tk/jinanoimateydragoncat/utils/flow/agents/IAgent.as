package tk.jinanoimateydragoncat.utils.flow.agents {
	
	//{ ======= import
	import tk.jinanoimateydragoncat.utils.flow.data.JDM;
	import tk.jinanoimateydragoncat.utils.flow.data.IAM;
	//} ======= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * 
	 */
	public interface AbstractAgent {
		
		function listen(eventType:String, details:Object):void;
		function get_envRef():AbstractAgent;
		function isAlive():Boolean;
		function setAlive(a:Boolean):void;
		
	}
}