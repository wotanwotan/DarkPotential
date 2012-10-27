using UnityEngine;
using System.Collections;

public class ForceDrawOrder : MonoBehaviour {


	public GameObject[] objects;
	private Material[] _materials;

	// Use this for initialization
	void Awake () {
		for (int i = 0; i < objects.Length; i++) {

			MeshRenderer[] mrs = objects[i].GetComponentsInChildren<MeshRenderer>();
			foreach (MeshRenderer mr in mrs) {
				mr.material.renderQueue += (i+10); // Move everything later i+10 in the render queue

			}


		}

	}


}