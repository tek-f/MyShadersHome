using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeMaterial : MonoBehaviour
{
    [SerializeField] Material shaderMaterial;
    [SerializeField] Material unshaderMaterial;
    [SerializeField] Renderer renderer;
    bool shadered;
    private void Start()
    {
        renderer = GetComponent<Renderer>();
        renderer.material = shaderMaterial;
        shadered = true;
    }
    void Update()
    {
        if(Input.GetMouseButtonDown(1))
        {
            if (shadered == true)
            {
                renderer.material = unshaderMaterial;
                shadered = false;
            }
            else
            {
                renderer.material = shaderMaterial;
                shadered = true;
            }
        }
    }
}
