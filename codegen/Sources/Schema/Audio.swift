let audio = StructDef("Audio") {
    FieldDef("url", type: .url)
        .required()
        .doc("The direct link to the audio file.")
    
    FieldDef("description", type: .string)
        .doc("The textual description of this audio file.")
}
.doc("""
    Note: full support for audio files will come in a future version of
    Smithereen. Currently, only the data provided by the remote server is
    returned, including a direct link to the audio file on that server.
    """)