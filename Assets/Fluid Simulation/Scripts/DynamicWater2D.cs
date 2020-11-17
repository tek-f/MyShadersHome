using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DynamicWater2D : MonoBehaviour
{
    [System.Serializable]
    public struct Bound
    {
        public float top;
        public float right;
        public float left;
        public float bottom;
    }

    [Header("Water Settings")]
    public Bound bound;
    public int quality;
    public Material waterMaterial;
    public GameObject splash;

    [Header("Physics Settings")]
    public float spring = 0.2f;
    public float damping = 0.1f;
    public float spread = 0.1f;
    public float collisionVelocityFector = 0.04f;

    private Vector3[] verticies;
    private Mesh mesh;

    private float[] velocities;
    private float[] accelerations;
    private float[] leftDeltas;
    private float[] rightDeltas;

    private float timer;

    private void GenerateMesh()
    {
        float range = (bound.right - bound.left) / (quality - 1);
        verticies = new Vector3[quality * 2];

        velocities = new float[quality];
        accelerations = new float[quality];
        leftDeltas = new float[quality];
        rightDeltas = new float[quality];

        //Generate the verticies
        for (int i = 0; i < quality; i++)
        {
            verticies[i] = new Vector3(bound.left + (i * range), bound.top, 0);
            verticies[i + quality] = new Vector3(bound.left + (i * range), bound.bottom, 0);
        }

        // generate triangles
        int[] template = new int[6];
        template[0] = quality;
        template[1] = 0;
        template[2] = quality + 1;
        template[3] = 0;
        template[4] = 1;
        template[5] = quality + 1;

        int marker = 0;
        int[] tris = new int[((quality - 1) * 2) * 3];
        for (int i = 0; i < tris.Length; i++)
        {
            tris[i] = template[marker++]++;
            if (marker >= 6)
            {
                marker = 0;
            }
        }

        //Generate the mesh
        MeshRenderer meshRenderer = GetOrAddComponent<MeshRenderer>();
        if (waterMaterial != null) meshRenderer.sharedMaterial = waterMaterial;

        MeshFilter filter = GetOrAddComponent<MeshFilter>();
        if (mesh == null)
        {
            mesh = new Mesh();
        }
        else
        {
            mesh.Clear();
        }

        mesh.vertices = verticies;
        mesh.triangles = tris;
        mesh.RecalculateNormals();
        mesh.RecalculateBounds();
        mesh.name = "Water";

        filter.mesh = mesh;
    }

    private bool PointIsInsideCircle(Vector2 point, Vector2 center, float radius)
    {
        return Vector2.Distance(point, center) < radius;
    }

    public void Splash(Collider2D collider, float force)
    {
        timer = 3f;
        float radius = collider.bounds.center.x - collider.bounds.min.x;
        Vector2 centre = new Vector2(collider.bounds.center.x, bound.top);

        //instantiating the splash particles
        if (splash != null)
        {
            GameObject newSplash = Instantiate(splash, new Vector3(centre.x, centre.y, 0), Quaternion.Euler(0, 0, 60));
            Destroy(newSplash, 2f);
        }
        //calculate velocitites
        for (int i = 0; i < quality; i++)
        {
            if (PointIsInsideCircle(verticies[i], centre, radius))
            {
                velocities[i] = force;
            }
        }
    }

    private T GetOrAddComponent<T>() where T : Component
    {
        T component = gameObject.GetComponent<T>();
        if (component == null)
        {
            component = gameObject.AddComponent<T>();
        }
        return component;
    }

    private void OnValidate()
    {
        GenerateMesh();
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        Rigidbody2D rigidbody = collision.GetComponent<Rigidbody2D>();
        Splash(collision, rigidbody.velocity.y * collisionVelocityFector);
    }

    private void Start()
    {
        BoxCollider2D collider = GetOrAddComponent<BoxCollider2D>();
        collider.isTrigger = true;
        GenerateMesh();
    }

    private void Update()
    {
        if (timer <= 0)
            return;

        timer -= Time.deltaTime;

        //Update Physics
        for (int i = 0; i < quality; i++)
        {
            float force = spring * (verticies[i].y - bound.top) + velocities[i] * damping;
            accelerations[i] = -force;
            verticies[i].y += velocities[i];
            velocities[i] += accelerations[i];
        }

        //Affect neighbouring mesh verts
        for (int i = 0; i < quality; i++)
        {
            if (i > 0)
            {
                leftDeltas[i] = spread * (verticies[i].y - verticies[i - 1].y);
                velocities[i - 1] += leftDeltas[i];
            }
            if (i < quality - 1)
            {
                rightDeltas[i] = spread * (verticies[i].y - verticies[i + 1].y);
                velocities[i + 1] += rightDeltas[i];
            }
        }

        //Update mesh verticies
        mesh.vertices = verticies;
    }
}