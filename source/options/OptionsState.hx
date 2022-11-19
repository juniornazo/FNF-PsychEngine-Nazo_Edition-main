package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	//if (ClientPrefs.languaGame == 'English') var options:Array<String> = ['Language','Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	//else if (ClientPrefs.languaGame == 'Portuguese') var options:Array<String> = ['Idioma','Cores das Notas', 'Controles', 'Ajuste de Delay e Combo', 'Graficos', 'Visuais e UI', 'Gameplay'];
	//else if (ClientPrefs.languaGame == 'Spanish') var options:Array<String> = ['Idioma','Nota de Colores', 'Controls', 'Ajuste de Retardo y Combo', 'Graficos', 'Efectos Visuales y UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	var options:Array<String> = ['Language','Note Colors', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	var optPT:Array<String> = ['Idioma','Cores das Notas', 'Controles', 'Ajuste de Delay e Combo', 'Graficos', 'Visuais e UI', 'Gameplay'];
	var optSP:Array<String> = ['Idioma','Nota de Colores', 'Controls', 'Ajuste de Retardo y Combo', 'Graficos', 'Efectos Visuales y UI', 'Gameplay'];

	function openSelectedSubstate(label:String) {
		if (ClientPrefs.languaGame == 'English'){
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
			case 'Language':
				LoadingState.loadAndSwitchState(new options.LanguageState());
		}
		}
		else if (ClientPrefs.languaGame == 'Portuguese'){
		switch(label) {
			case 'Cores das Notas':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graficos':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Efectos Visuales y UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Ajuste de Delay e Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
			case 'Idioma':
				LoadingState.loadAndSwitchState(new options.LanguageState());
			}
		}
		else if (ClientPrefs.languaGame == 'Spanish'){
		switch(label) {
			case 'Nota de Colores':
				openSubState(new options.NotesSubState());
			case 'Controles':
				openSubState(new options.ControlsSubState());
			case 'Graficos':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuais e UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Ajuste de Retardo y Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
			case 'Idioma':
				LoadingState.loadAndSwitchState(new options.LanguageState());
			}
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		if (ClientPrefs.languaGame == 'English'){
		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}
		}

		if (ClientPrefs.languaGame == 'Portuguese'){
		for (i in 0...optPT.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, optPT[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (optPT.length / 2))) + 50;
			grpOptions.add(optionText);
		}
		}

		if (ClientPrefs.languaGame == 'Spanish'){
		for (i in 0...optSP.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, optSP[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (optSP.length / 2))) + 50;
			grpOptions.add(optionText);
		}
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
			openSelectedSubstate(optPT[curSelected]);
			openSelectedSubstate(optSP[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}