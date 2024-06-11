from ultralytics import YOLO

model = YOLO("yolov8m.pt")

# Training.
results = model.train(
    data="pavment_defects_standard.yaml",
    imgsz=416,
    epochs=300,
    batch=16,
    name="yolov8m_split_by_video",
)

model.val(
    data="pavment_defects_standard.yaml",
    imgsz=416,
    batch=1,
    name="yolov8m_split_by_video_test",
    split="test",
    plots=True,
    iou=0.3,
    conf=0.25,
)
