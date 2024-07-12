export MODEL_NAME="path/to/pretrained_model"  # 这里放入pretrain model, 可以是roentgen，也可以是stable diffusion官方的模型
export DATASET_NAME="path/to/dataset" # 这里是一个csv，中间有两列，分别是image路径和对应的text
export CUDA_VISIBLE_DEVICES="4,5,6,7" # 训练使用的GPU
export WANDB_MODE="offline"

accelerate launch --num_processes=4 --mixed_precision="fp16" train_text_to_image.py \
  --pretrained_model_name_or_path=$MODEL_NAME \
  --train_data_dir=$DATASET_NAME \
  --use_ema \
  --resolution=512 --center_crop --random_flip \
  --train_batch_size=100 \
  --gradient_accumulation_steps=4 \
  --gradient_checkpointing \
  --max_train_steps=2000 \
  --learning_rate=1e-05 \
  --max_grad_norm=1 \
  --lr_scheduler="constant" \
  --lr_warmup_steps=100 \
  --validation_prompts "EGFR Sensitive Type, Stage-4" "EGFR Wild Type, Stage-4" "EGFR Resistant Type, Stage-4" \  # 可以放一些测试的prompts, 修改train_text_to_image.py的第165行内容
  --validation_epochs=1 \
  --report_to="wandb" \
  # --resume_from_checkpoint="path/to/checkpoint" # 选择从哪一个checkpoint开始继续训练