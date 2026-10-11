#!/bin/bash
set -e

# 1. Instalar herramientas de alta velocidad y dependencias globales
apt-get update && apt-get install -y aria2
pip install --upgrade pip hf_transfer

# 2. Entrar al espacio de trabajo y clonar ComfyUI
cd /workspace
if [ ! -d "ComfyUI" ]; then
    git clone https://github.com/comfyanonymous/ComfyUI.git
fi
cd ComfyUI
pip install -r requirements.txt

# 3. Clonar los Custom Nodes esenciales e instalar dependencias
cd custom_nodes
if [ ! -d "ComfyUI-dapaoAPI" ]; then
    git clone https://github.com/paolaoshi/ComfyUI-dapaoAPI.git
fi
cd ComfyUI-dapaoAPI && pip install --no-cache-dir -r requirements.txt && cd ..

if [ ! -d "ComfyUI-Easy-Use" ]; then
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git
fi
cd ComfyUI-Easy-Use && pip install --no-cache-dir -r requirements.txt && cd ..

# 4. Crear estructura de carpetas (incluida la carpeta loras)
mkdir -p /workspace/ComfyUI/models/checkpoints \
         /workspace/ComfyUI/models/vae \
         /workspace/ComfyUI/models/text_encoders \
         /workspace/ComfyUI/models/diffusion_models \
         /workspace/ComfyUI/models/loras

# 5. Descargar modelos a MÁXIMA VELOCIDAD con aria2c (16 hilos por archivo)
echo "Iniciando descargas multihilo de alta velocidad..."

aria2c -x 16 -s 16 -k 1M -d /workspace/ComfyUI/models/checkpoints -o sam3.1_multiplex_fp16.safetensors \
"https://huggingface.co/Comfy-Org/sam3.1/resolve/main/checkpoints/sam3.1_multiplex_fp16.safetensors"

aria2c -x 16 -s 16 -k 1M -d /workspace/ComfyUI/models/vae -o minimax_h3_audio_vae_fp32.safetensors \
"https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_audio_vae_fp32.safetensors"

aria2c -x 16 -s 16 -k 1M -d /workspace/ComfyUI/models/vae -o minimax_h3_video_vae_fp16.safetensors \
"https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/vae/minimax_h3_video_vae_fp16.safetensors"

aria2c -x 16 -s 16 -k 1M -d /workspace/ComfyUI/models/text_encoders -o qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors \
"https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors"

aria2c -x 16 -s 16 -k 1M -d /workspace/ComfyUI/models/diffusion_models -o minimax_h3_ref2va_pruned_int8_convrot.safetensors \
"https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors"

aria2c -x 16 -s 16 -k 1M -d /workspace/ComfyUI/models/loras -o minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors \
"https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main/loras/minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors"

echo "¡Entorno instalado y listo para usar!"
