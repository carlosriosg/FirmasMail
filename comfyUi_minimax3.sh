#!/bin/bash
# 1. Entrar al espacio de trabajo
cd /workspace

# 2. Clonar ComfyUI e instalar dependencias básicas
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
pip install -r requirements.txt

# 3. Clonar los Custom Nodes esenciales (DapaoAPI, EasyUse, etc.)
cd custom_nodes
git clone https://github.com/paolaoshi/ComfyUI-dapaoAPI.git
cd ComfyUI-dapaoAPI && pip install -r requirements.txt && cd ..
git clone https://github.com/yolain/ComfyUI-Easy-Use.git
cd ComfyUI-Easy-Use && pip install -r requirements.txt && cd ..

# 4. Crear estructura de carpetas
cd /workspace/ComfyUI/models
mkdir -p checkpoints vae text_encoders diffusion_models

# 5. Descargar los modelos de MiniMax H3 y SAM 3.1
wget -O checkpoints/sam3.1_multiplex_fp16.safetensors https://huggingface.co/Comfy-Org/sam3.1/resolve/main/checkpoints/sam3.1_multiplex_fp16.safetensors
wget -O vae/minimax_h3_audio_vae_fp32.safetensors https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors
wget -O vae/minimax_h3_video_vae_fp16.safetensors https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_fp16.safetensors
wget -O text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors
wget -O diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors

echo "¡Entorno instalado y listo para usar!"