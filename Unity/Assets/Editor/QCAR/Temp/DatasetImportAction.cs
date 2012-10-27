using UnityEditor;
using UnityEngine;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;

public class DatasetImportAction : AssetPostprocessor
{
    // Path to this script
    private const string SCRIPT_PATH =
        "Assets/Editor/QCAR/Temp/DatasetImportAction.cs";
    private const string WINDOW_SCRIPT_PATH =
        "Assets/Editor/QCAR/Temp/DatasetImportWindow.cs";

    // Paths to QCAR specific assets
    private const string DATA_SET_PATH =
        "Assets/StreamingAssets/QCAR/";
    private const string DAT_PATH =
        "Assets/StreamingAssets/QCAR/qcar-resources.dat";
    private const string CONFIG_XML_PATH =
        "Assets/StreamingAssets/QCAR/config.xml";
    private const string TARGET_TEXTURES_PATH =
        "Assets/Editor/QCAR/ImageTargetTextures/";

    // Path to a QCAR 1.0 specific script
    private const string QCAR_1_0_SCRIPT_PATH =
        "Assets/Qualcomm Augmented Reality/Scripts/TrackerBehaviour.cs";
    // Path to a QCAR 1.5 specific script
    private const string QCAR_1_5_SCRIPT_PATH =
        "Assets/Qualcomm Augmented Reality/Scripts/QCARBehaviour.cs";

    // Note that these static variables are reset during each editor compile phase
    private static string mDatasetConfigPath = null;
    private static string mDatasetDatPath = null;
    private static List<string> mDatasetTexturePaths = new List<string>();
    private static bool mShouldProcessDataset = false;
    private static bool mIsFinished = false;

    public enum QCARVersion
    {
        QCAR_1_0,
        QCAR_1_5,
        UNKNOWN
    }


    // This method is called by Unity whenever assets are updated (deleted,
    // moved or added)
    public static void OnPostprocessAllAssets(string[] importedAssets,
                                              string[] deletedAssets,
                                              string[] movedAssets,
                                              string[] movedFromAssetPaths)
    {
        // This script will remain active even after this file is deleted
        // Guard against additional processing after initial import
        if (mIsFinished)
        {
            return;
        }

        foreach (string importedAsset in importedAssets)
        {
            string extension = Path.GetExtension(importedAsset);

            if (Compare(importedAsset, SCRIPT_PATH))
            {
                // Trigger action when this script is imported
                // But wait until all files are processed
                mShouldProcessDataset = true;
            }
            else if (Compare(extension, ".xml"))
            {
                // Store the config file path
                mDatasetConfigPath = importedAsset;
            }
            else if (Compare(extension, ".dat"))
            {
                // Store the dat file path
                mDatasetDatPath = importedAsset;
            }
            else if (Compare(extension, ".jpg") || Compare(extension, ".png"))
            {
                // Store the texture file paths
                mDatasetTexturePaths.Add(importedAsset);
            }
        }

        if (mShouldProcessDataset)
        {
            mShouldProcessDataset = false;
            ProcessDataset();
            SelfDestruct();
        }
    }


    // Process the Dataset according to the QCAR version
    public static void ProcessDataset()
    {
        Debug.Log("Processing Dataset");

        // Attempt to detect the QCAR version
        QCARVersion version = CheckQCARVersion();
        Debug.Log("QCAR Version: " + version);

        if (version == QCARVersion.UNKNOWN)
        {
            // Open a window to prompt the user for the desired version
            // Note we use reflection to avoid errors when these scripts are deleted
            Type windowType = Type.GetType("DatasetImportWindow");
            if (windowType != null)
            {
                windowType.InvokeMember("ShowWindow",
                        BindingFlags.InvokeMethod | BindingFlags.Static | BindingFlags.Public,
                        null, null, null);
            }
        }
        else
        {
            if (version == QCARVersion.QCAR_1_0)
            {
                // Downgrade dataset for use with 1.0
                DowngradeDataset();
            }
        }
    }


    // Downgrade a 1.5 dataset to work with QCAR 1.0
    public static void DowngradeDataset()
    {
        // Only downgrade if we know the location of the config and dat files
        if (mDatasetConfigPath == null || mDatasetDatPath == null)
        {
            return;
        }

        Debug.Log("Configuring Dataset for QCAR 1.0.x");

        // Rename the config file
        if (mDatasetConfigPath != null)
        {
            AssetDatabase.DeleteAsset(CONFIG_XML_PATH);
            AssetDatabase.MoveAsset(mDatasetConfigPath, CONFIG_XML_PATH);
        }

        // Rename the dat file
        if (mDatasetDatPath != null)
        {
            AssetDatabase.DeleteAsset(DAT_PATH);
            AssetDatabase.MoveAsset(mDatasetDatPath, DAT_PATH);
        }

        // Move the image target textures
        if (mDatasetTexturePaths.Count > 0)
        {
            string textureDirectory = Path.GetDirectoryName(mDatasetTexturePaths[0]);

            foreach (string currentPath in mDatasetTexturePaths)
            {
                string finalPath = TARGET_TEXTURES_PATH + Path.GetFileName(currentPath);
                AssetDatabase.DeleteAsset(finalPath);
                AssetDatabase.MoveAsset(currentPath, finalPath);
            }

            AssetDatabase.DeleteAsset(textureDirectory);
        }
    }


    // Case insensitive string comparison
    public static bool Compare(string s1, string s2)
    {
        return s1.IndexOf(s2, System.StringComparison.OrdinalIgnoreCase) != -1;
    }


    // Attempt to automatically detect the QCAR version
    public static QCARVersion CheckQCARVersion()
    {
        // AssetDatabase.AssetPathToGUID returns an empty string if the script isn't present
        if (AssetDatabase.AssetPathToGUID(QCAR_1_5_SCRIPT_PATH).Length > 0)
        {
            return QCARVersion.QCAR_1_5;
        }
        else if (AssetDatabase.AssetPathToGUID(QCAR_1_0_SCRIPT_PATH).Length > 0)
        {
            return QCARVersion.QCAR_1_0;
        }
        else
        {
            return QCARVersion.UNKNOWN;
        }
    }


    // Delete this file
    // Note that the script will persist in memory until the next editor compile phase
    public static void SelfDestruct()
    {
        mIsFinished = true;
        AssetDatabase.DeleteAsset(SCRIPT_PATH);

        // This causes an error
        //AssetDatabase.DeleteAsset(WINDOW_SCRIPT_PATH);
    }
}
