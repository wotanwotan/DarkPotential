
using UnityEditor;
using UnityEngine;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.IO;
using System.Linq;
using System.Text;
using System.Security.Cryptography;

public class Build {
	
	static string[] bundledScenes = new string[] {
		"Assets/Ad-Dispatch/Scenes/Initialization.unity",
		"Assets/Ad-Dispatch/Scenes/StrippingIncludes.unity",
		"Assets/Ad-Dispatch/Scenes/Menu.unity",
		"Assets/Ad-Dispatch/Scenes/Comic.unity",
		"Assets/Ad-Dispatch/Scenes/DVD_PhotoShoot.unity",
		"Assets/Ad-Dispatch/Scenes/Bring_spidey_to_life.unity",
		"Assets/Ad-Dispatch/Scenes/DVD_Unlock.unity"
		/*"Assets/Ad-Dispatch/Scenes/WhatsNext.unity",
		"Assets/Ad-Dispatch/Scenes/MeetSpidey_Base.unity",
		"Assets/Ad-Dispatch/Scenes/Practice.unity",
		"Assets/Ad-Dispatch/Scenes/Game.unity"
		"Assets/Ad-Dispatch/Scenes/MeetSpidey_Flyer.unity",
		"Assets/Ad-Dispatch/Scenes/Unlock.unity",
		"Assets/Ad-Dispatch/Scenes/Photo_ComicScene.unity",
		"Assets/Ad-Dispatch/Scenes/Photo_HangingSpidey.unity",
		"Assets/Ad-Dispatch/Scenes/Photo_FlagpoleSpidey.unity",
		"Assets/Ad-Dispatch/Scenes/Photo_TruckScene.unity"
		*/
	};
	
	[MenuItem ("Build/Initialization %i")]
	static void BuildOnlyInitialization() {
		BuildPipeline.BuildPlayer( bundledScenes, EditorUserBuildSettings.GetBuildLocation(EditorUserBuildSettings.activeBuildTarget), EditorUserBuildSettings.activeBuildTarget, BuildOptions.AutoRunPlayer); 
	}
	
	[MenuItem ("Build/Build %g")]
    static void ShowDialog () {
		//initalize MD5 File
		StreamWriter file = new StreamWriter("Assets/Ad-Dispatch/Resources/Loading/md5.txt");
		file.Write("");
		file.Close();
		
		// Get the list of scenes in the build settings
		string[] levels = new string[EditorBuildSettings.scenes.Length];
		
		// MAKE THIS WORK?
		//List<Object> includes = new List<Object>();	
      	
		List<string> sceneList = new List<string>();
		
		int n=0;
      	foreach (EditorBuildSettingsScene scene in EditorBuildSettings.scenes) {
       		levels[n++] = scene.path;
			
			
			
			// Don't build Streaming bundles if it's a development build
			if (!EditorUserBuildSettings.development) {
				bool shouldBundleScene = true;
				foreach(string builtIn in bundledScenes) {
					if (builtIn.Contains(scene.path)) {
						shouldBundleScene = false;
					}
				}
				if (shouldBundleScene) {
					Debug.Log ("Building: " + scene.path);
					buildStreamedScene(scene.path, "Experiences");
					sceneList.Add(Path.GetFileNameWithoutExtension(scene.path));
					generateMD5Hash(scene.path);
				}
			}
			
		}
		
		//generateStrippingIncludes(includes.ToArray());
		
		generateSceneList(sceneList);
		
		// Do a standard unity build, using the editor settings
		//if ( EditorUserBuildSettings.development ) {
		if(	EditorUserBuildSettings.development ){
			EditorUtility.DisplayDialog( "Beginning development build", EditorUserBuildSettings.activeBuildTarget.ToString(), "OK");
			BuildPipeline.BuildPlayer( levels, EditorUserBuildSettings.GetBuildLocation(EditorUserBuildSettings.activeBuildTarget), EditorUserBuildSettings.activeBuildTarget, BuildOptions.Development | BuildOptions.AutoRunPlayer); 
		} else {
			// build for streaming
			
			// Find a way to check if there is a device connected. If there isn't, build with BuildOptions.None otherwise no APK is created! 
    		BuildPipeline.BuildPlayer( bundledScenes, EditorUserBuildSettings.GetBuildLocation(EditorUserBuildSettings.activeBuildTarget), EditorUserBuildSettings.activeBuildTarget, BuildOptions.AutoRunPlayer);
		} 
		
		
		EditorUtility.DisplayDialog( "Build Completed", EditorUserBuildSettings.activeBuildTarget.ToString(), "OK");
	}
	
	static void buildStreamedScene( string scenePath, string type ) {
		string path = "Assets/StreamedSceneBundles/" + EditorUserBuildSettings.activeBuildTarget.ToString() + "/";		
		if (!Directory.Exists(path)) {
			Directory.CreateDirectory(path);
		}
		
		BuildPipeline.BuildStreamedSceneAssetBundle(new string[]{scenePath}, path + Path.GetFileNameWithoutExtension(scenePath) + ".unity3d", EditorUserBuildSettings.activeBuildTarget);
	}
	
	
	// Generates a list of scenes which will be automatically cached at app launch 
	// THIS SOMETIMES CAUSES UNITY TO CRASH? FIX IT. 
	static void generateSceneList(List<string> ui) {
		StreamWriter file = new StreamWriter("Assets/Ad-Dispatch/Resources/Loading/scenes.txt");
		foreach (string scene in ui) {
			file.Write(scene + ",");
		}
		file.Close();
	}
	
	//Generate md5 Hashs
	
	static void generateMD5Hash(string scenePath){
		string[] scenePathArray = scenePath.Split('/');
		string sceneName = scenePathArray[scenePathArray.Length-1];
		Debug.Log(sceneName);
		StreamWriter file = File.AppendText("Assets/Ad-Dispatch/Resources/Loading/md5.txt");
		if (!scenePath.Equals("") || scenePath == null){
			file.Write(sceneName+"3d" +':'+ GetHash(sceneName)+",");
		}
		file.Close();
	}
	
	public static string GetHash(string pathSrc)
    {
        //string pathDest = "copy_" + pathSrc;

        //File.Copy("Assets/StreamedSceneBundles/"+EditorUserBuildSettings.activeBuildTarget.ToString() + "/"+pathSrc, "Assets/StreamedSceneBundles/"+EditorUserBuildSettings.activeBuildTarget.ToString() + "/"+pathDest, true);

        string md5Result;
        StringBuilder sb = new StringBuilder();
        MD5 md5Hasher = MD5.Create();

        using (FileStream fs = File.OpenRead("Assets/StreamedSceneBundles/"+EditorUserBuildSettings.activeBuildTarget.ToString() + "/"+pathSrc+"3d"))
        {
            foreach (byte b in md5Hasher.ComputeHash(fs))
                sb.Append(b.ToString("x2").ToLower());
        }

        md5Result = sb.ToString();

        //File.Delete(pathDest);

        return md5Result;
    }
	
	
	
	
	// IS THIS USEFUL NO EVERYTHING IS BROKEN FUCK
	static void generateStrippingIncludes(Object[] reqs) {
		
		string header = "using UnityEngine; \n" +
						"using System.Collections; \n\n" +
						"public class StrippingIncludes : MonoBehaviour {";
		
		string footer = "}";
		
		string includes = "";
		
		foreach (Object o in reqs) {
			if (o.GetType().ToString().IndexOf("UnityEditory") > 0) {
				continue;
			} else {
				includes += "private " + o.GetType().ToString() + " dummy" + (int)(System.DateTime.Now.Millisecond * (Random.value * 100)) + ";\n";	
			}
		}
		
		StreamWriter file = new StreamWriter("Assets/Ad-Dispatch/Scripts/StrippingIncludes.cs");
		
		file.WriteLine(header);
		file.WriteLine(includes);
		file.WriteLine(footer);
	
		file.Close();		
		
	}
	
	
	// PROBABLY CAN DELETE BELOW?
	static Object[] getFilesToBundle(string scenePath) {
		
		List<Object> db = new List<Object>();
		foreach (string file in Directory.GetFiles(scenePath, "*")){
			Debug.Log(file);
			foreach(Object o in AssetDatabase.LoadAllAssetsAtPath(file)) {
				db.Add(o);	
			}
		}
		EditorUtility.DisplayDialog(scenePath, db.Count.ToString(), "OK");
		return db.ToArray();
	}
				
	static Object getMainAsset(string scenePath) {
		Object mainAsset = AssetDatabase.LoadAssetAtPath(scenePath+"ui-elements.txt", typeof(TextAsset));
		if (mainAsset == null)
			EditorUtility.DisplayDialog("Error", "Can't find main asset. Needs ui-elements.txt", "OK");
		return mainAsset;
	}
}
