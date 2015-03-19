package com.luchanso.lrating;
import openfl.events.Event;

/**
 * ...
 * @author Loutchansky Oleg
 */
class LRatingEvent extends Event
{

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false)
	{
		super(type, bubbles, cancelable);
	}
	
	public static var TABLE_CLOSE	:String = "lratingTClose";
	public static var TABLE_SHOW	:String = "lratingTShow";
	public static var TABLE_HIDE	:String = "lratingTHide";
	
	public static var SCORE_CLOSE	:String = "lratingSClose";
	public static var SCORE_SHOW	:String = "lratingSShow";
	public static var SCORE_HIDE	:String = "lratingSHide";
}