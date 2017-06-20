LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

# QCamera3Factory.cpp has unused parameters.
# QCamera3Channel.cpp compares array 'str' to a null pointer.
LOCAL_CLANG_CFLAGS += -Wno-unused-parameter -Wno-tautological-pointer-compare

LOCAL_SRC_FILES := \
        QCamera2Factory.cpp \
        QCamera2Hal.cpp \
        QCamera2HWI.cpp \
        QCameraMem.cpp \
        ../util/QCameraQueue.cpp \
        ../util/QCameraCmdThread.cpp \
        QCameraStateMachine.cpp \
        QCameraChannel.cpp \
        QCameraStream.cpp \
	QCameraPostProc.cpp \
        QCamera2HWICallbacks.cpp \
        QCameraParameters.cpp \
        QCameraThermalAdapter.cpp \
        wrapper/QualcommCamera.cpp \
	GNCameraParameters.cpp

#Gionee <zhuangxiaojian> <2013-08-20> modify for CR00867956 begin
#LOCAL_CFLAGS = -Wall -Werror
#Gionee <zhuangxiaojian> <2013-08-14> modify for CR00867956 end

#Debug logs are enabled
#LOCAL_CFLAGS += -DDISABLE_DEBUG_LOG

ifeq ($(TARGET_USE_VENDOR_CAMERA_EXT),true)
LOCAL_CFLAGS += -DUSE_VENDOR_CAMERA_EXT
endif
ifneq ($(call is-platform-sdk-version-at-least,18),true)
LOCAL_CFLAGS += -DUSE_JB_MR1
endif

LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/../stack/common \
        frameworks/native/include/media/openmax \
        hardware/qcom/display/msm8974/libgralloc \
        hardware/qcom/media/msm8974/libstagefrighthw \
	system/media/camera/include \
        $(LOCAL_PATH)/../../mm-image-codec/qexif \
        $(LOCAL_PATH)/../../mm-image-codec/qomx_core \
        $(LOCAL_PATH)/../util \
        $(LOCAL_PATH)/wrapper

ifeq ($(TARGET_USE_VENDOR_CAMERA_EXT),true)
LOCAL_C_INCLUDES += hardware/qcom/display/libgralloc
else
LOCAL_C_INCLUDES += hardware/qcom/display/msm8974/libgralloc
endif
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/media
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

LOCAL_SHARED_LIBRARIES := libcamera_client liblog libhardware libutils libcutils libdl
LOCAL_SHARED_LIBRARIES += libmmcamera_interface libmmjpeg_interface

#Gionee <zhuangxiaojian> <2014-05-20> modify for CR01261494 begin
ifeq ($(GN_CAM_FEATURE_SUPPORT),true)
LOCAL_SHARED_LIBRARIES += libgn_camera_feature
LOCAL_C_INCLUDES += external/libgn_camera_feature/include
endif
#Gionee <zhuangxiaojian> <2014-05-20> modify for CR01261494 end

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

include $(LOCAL_PATH)/test/Android.mk
