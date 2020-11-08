using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace MyShaders.Test
{
    public class RecieveRaycast : MonoBehaviour
    {
        public MeshRenderer renderer;
        public Material instanceMaterial;

        public void SetHitPosition(Vector3 hitPosition)
        {
            Vector3 _hitVector = gameObject.transform.InverseTransformPoint(hitPosition);
            instanceMaterial.SetVector("_hitPosition", _hitVector);
        }
        private void Start()
        {
            renderer = gameObject.GetComponent<MeshRenderer>();
            instanceMaterial = renderer.material;
        }
        private void Update()
        {

        }
    }
}