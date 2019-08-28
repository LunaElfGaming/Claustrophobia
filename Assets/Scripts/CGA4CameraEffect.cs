using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class CGA4CameraEffect : MonoBehaviour {

	private Material material;
	Shader halfTone;
	public float thresBound;

	// Creates a private material used to the effect
	void Awake () {
		halfTone = Shader.Find("Hidden/CGAHalftone");
		material = new Material( halfTone );
	}

	private void Update() {
		Shader.SetGlobalFloat("thresBound", thresBound);
	}

	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination) {
		Graphics.Blit (source, destination, material);
		
	}
}
