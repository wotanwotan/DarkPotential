using UnityEngine;
using System.Collections;

public class StrippingIncludes : MonoBehaviour {
	
#pragma warning disable 0414
#pragma warning disable 0108
	// Stripping includes!
	private BoxCollider boxcollider = null; 
	private SphereCollider spherecollider = null;
	private CapsuleCollider capsulecollider = null;
	private MeshCollider meshcollider = null;
	private MeshFilter meshfilter = null;
	private MeshRenderer meshrenderer = null;
	private SkinnedMeshRenderer skinnedmeshrenderer = null;
	private Transform transform = null;
	private Light light = null;
	private ParticleEmitter particleemitter = null;
	private ParticleAnimator particleanimator = null;
	private ParticleRenderer particlerenderer = null;
	private Particle particleInclude; // = new Particle();
#pragma warning restore 0108
#pragma warning restore 0414
	
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
