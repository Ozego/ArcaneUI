﻿using UnityEngine;
using UnityEngine.UI;


//Script is kept for legacy, is not needed. Use fixed dy = abs(ddy(i.uv.y)) in shader instead of _TexelSize.y
[ExecuteInEditMode]
public class SetUIMaterialProperties : MonoBehaviour
{
    private Material material;
    private RectTransform rect;
    void Update()
    {
        if(material == null) material = GetComponent<Image>().material;
        if(rect == null) rect = GetComponent<RectTransform>();
        float x = Mathf.Abs(rect.sizeDelta.x*transform.lossyScale.x);
        float y = Mathf.Abs(rect.sizeDelta.y*transform.lossyScale.y);
        material.SetVector("_TexelSize", new Vector4(1f/x, 1f/y, x, y));
    }
}
