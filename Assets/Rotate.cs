using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour {
    public Vector3 rotation = Vector3.up*60;
    Transform myTransform;
    private void Awake()
    {
        myTransform = GetComponent<Transform>();

    }
    void Update () {
        myTransform.Rotate(rotation*Time.deltaTime);

    }
}
