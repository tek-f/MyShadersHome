using UnityEngine;
using UnityEngine.SceneManagement;

public class ResetScene : MonoBehaviour
{
    public void LoadScene(int _index)
    {
        SceneManager.LoadScene(_index);
    }
}