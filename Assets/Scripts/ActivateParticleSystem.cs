using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ActivateParticleSystem : MonoBehaviour
{
    [SerializeField] GameObject particleSystem;
    void Update()
    {
        if(Input.GetMouseButtonDown(0))
        {
            particleSystem.SetActive(!particleSystem.activeSelf);
        }
    }
}
