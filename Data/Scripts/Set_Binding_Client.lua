local BINDING = script:GetCustomProperty("Binding")

script.parent.text = Input.GetActionInputLabel(BINDING)