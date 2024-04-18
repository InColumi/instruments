def insert_to_1358():
    path = 'file:///home/user/Desktop/Projects/Справочники для загрузки/Фед/1.2.643.5.1.13.13.11.1358_3.22.xlsx'
    url = 'postgres://user:pass@IP:5432/NAME_DB'
    df: DataFrame = pd.read_excel(path)
    print(df.shape)
    print(df.columns)
    # return
    column_name = {'Код': 'code',
                   'Серия документа': 'SERIES_REQUIRED'}
    # print({i: '' for i in df.columns})
    # return
    # df.drop(index=0, inplace=True)

    df.rename(column_name, axis='columns', inplace=True)
    df.rename(str.lower, axis='columns', inplace=True)
    for i in df.columns:
        print(f'{i} text, ')

    print('Start insert')
    df.to_sql(name='gisz_1358', schema='sprav2016', con=create_engine(url), if_exists='append', index=False,
              method='multi')
    print('End insert')
