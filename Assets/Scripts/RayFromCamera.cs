using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace MyShaders.Test
{
    public class RayFromCamera : MonoBehaviour
    {
        Camera camera;
        public Camera MyCamera
        {
            get
            {
                if (camera == null)
                {
                    camera = gameObject.GetComponent<Camera>();
                }
                return camera;
            }
        }
        void Update()
        {
            if (Input.GetMouseButtonDown(0))
            {
                Ray ray = MyCamera.ScreenPointToRay(Input.mousePosition);
                RaycastHit hit;
                if (Physics.Raycast(ray, out hit, 1000))
                {
                    RecieveRaycast recieveRaycast = hit.collider.gameObject.GetComponent<RecieveRaycast>();
                    if(recieveRaycast != null)
                    {
                        recieveRaycast.SetHitPosition(hit.point);
                    }
                }
            }
        }
    }
}