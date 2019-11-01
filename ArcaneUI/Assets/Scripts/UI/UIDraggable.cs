
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class UIDraggable : EventTrigger 
{
    private bool pointerIsDown;
    private Vector2 oldPosition;
    public void Update() 
    {
        if (pointerIsDown) 
        {
            Vector2 borders = GetComponentInParent<RectTransform>().sizeDelta + GetComponent<RectTransform>().sizeDelta/2f;
            borders.x = Mathf.Abs(borders.x);
            borders.y = Mathf.Abs(borders.y);
            transform.position = new Vector2
            (
                Mathf.Clamp(Input.mousePosition.x, borders.x, Screen.width  - borders.x), 
                Mathf.Clamp(Input.mousePosition.y, borders.y, Screen.height - borders.y)
            );
        }
    }
    public override void OnPointerDown( PointerEventData eventData ) => pointerIsDown = true;
    public override void OnPointerUp(   PointerEventData eventData ) => pointerIsDown = false;
}