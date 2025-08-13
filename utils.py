import numpy as np
from sklearn.metrics import confusion_matrix
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay

import matplotlib.pyplot as plt
import seaborn as sns



def plot_all_confusion_matrices(trained_pipelines, X_test, y_test, labels):
    n_models = len(trained_pipelines)
    cols = 2
    rows = (n_models + 1) // cols

    fig, axes = plt.subplots(rows, cols, figsize=(12, rows * 5))
    axes = axes.flatten()

    for idx, (name, pipeline) in enumerate(trained_pipelines.items()):
        y_pred = pipeline.predict(X_test)
        cm = confusion_matrix(y_test, y_pred, labels=labels)

        sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
                    xticklabels=labels, yticklabels=labels, ax=axes[idx])
        axes[idx].set_title(f"{name} Confusion Matrix")
        axes[idx].set_xlabel("Predicted")
        axes[idx].set_ylabel("Actual")

    # Remove unused subplots
    for j in range(idx + 1, len(axes)):
        fig.delaxes(axes[j])

    plt.tight_layout()
    plt.show()



def plot_cv_confusion_matrices(models, X, y, cv):
    for name, model in models.items():
        print(f"\nModel: {name}")
        all_y_true = []
        all_y_pred = []

        for train_idx, val_idx in cv.split(X, y):
            # Split data
            X_train_fold, X_val_fold = X.iloc[train_idx], X.iloc[val_idx]
            y_train_fold, y_val_fold = y.iloc[train_idx], y.iloc[val_idx]

            # Train model
            pipeline = make_pipeline(StandardScaler(), model)
            pipeline.fit(X_train_fold, y_train_fold)

            # Predict
            preds = pipeline.predict(X_val_fold)
            all_y_true.extend(y_val_fold)
            all_y_pred.extend(preds)

        # Plot confusion matrix
        cm = confusion_matrix(all_y_true, all_y_pred, labels=np.unique(y))
        disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=np.unique(y))
        disp.plot(cmap='Blues')
        plt.title(f'Confusion Matrix: {name}')
        plt.show()
    