LRating
=============
**LRating** - game rating system on Haxe + OpenFL  

  Use to install:

```
haxelib git
Library name : lrating
Git path : https://github.com/Luchanso/LRating
```
 and add to your project.xml:

```xml
<haxelib name="lrating" />
```

Example use:
```Haxe
package;

import com.luchanso.lrating.TableRating;
import openfl.display.Sprite;

class Main extends Sprite
{
	var tableRating:TableRating;
	
	public function new() 
	{
		super();

		tableRating = new TableRating("MyGameName", 500, 100, "My rating table");

		// Nickname, Score, Position in table, Url (if exist)
		tableRating.addScore("Michael Nikman", "250", 1, "http://example.com");
		tableRating.addScore("Djon Kolt", "221", 2);
		tableRating.addScore("Lorem Isup", "189", 3);

		tableRating.x = 100;
		tableRating.y = 50;

		addChild(tableRating);
	}
	
}
```

Remoting server example:
```Haxe
package;

import com.luchanso.lrating.TableRating;
import openfl.display.Sprite;

class Main extends Sprite
{
	var tableRating:TableRating;
	
	public function new() 
	{
		super();

		tableRating = new TableRating("MyGameName", 500, 100, "My rating table");
		
		tableRating.connectToServer("http://localhost/lrating/");
		tableRating.connectionCallback = this.onConnect;

		tableRating.x = 100;
		tableRating.y = 50;

		addChild(tableRating);
	}

	function onConnect() 
	{
		/* Add new scores to server */
		for (i in 0...10)
		{
			tableRating.addToServer(new Score("Lorem " + Math.random() * 10000, i * 100 + Math.random() * 80, null, null));
		}
		
		/* Update RatingTable from server */
		tableRating.getDataFromServer();
	}
	
}
```