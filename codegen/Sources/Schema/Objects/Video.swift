let video = StructDef("Video") {
    FieldDef("url", type: .url)
        .required()
        .doc("""
            The direct link to the video file. Most probably an MP4 with H264
            and AAC, but no guarantees are made.
            """)
    
    FieldDef("width", type: .int)
        .doc("The width of the video.")
    
    FieldDef("height", type: .int)
        .doc("The height of the video.")
    
    blurhashField()
    
    FieldDef("description", type: .string)
        .doc("""
            The description for this video, often used as an “alt text” to
            describe the video for visually-impaired users.
            """)
}
.doc("""
    Note: full support for videos will come in a future version of Smithereen.
    Currently, only the data provided by the remote server is returned,
    including a direct link to the video file on that server.
    """)